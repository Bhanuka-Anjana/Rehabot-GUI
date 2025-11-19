import copy
import glob
from random import shuffle

import torch
from torch.utils.data import Dataset

import voicecomand.supports.supports as support_functions
import voicecomand.training.arguments as arguments

args = arguments.set_default_args()


def get_filenames(folder, file_types=("*.wav",)):
    filenames = []

    if not isinstance(file_types, tuple):
        file_types = [file_types]

    for file_type in file_types:
        filenames.extend(glob.glob(folder + "/" + file_type))
    # filenames.sort()
    shuffle(filenames)  # my_adding 2020-11-03
    return filenames


class AudioClass(object):
    """A wrapper around the audio data
    to provide easy access to common operations on audio data.
    """

    def __init__(self, data=None, sample_rate=None, filename=None, n_mfcc=12):
        if filename:
            self.data, self.sample_rate = support_functions.read_audio(
                filename, dst_sample_rate=None
            )
        elif len(data) and sample_rate:
            self.data, self.sample_rate = data, sample_rate
        else:
            assert (
                0
            ), "Invalid input. Use keyword to input either (1) filename, or (2) data and sample_rate"

        self.mfcc = None
        self.n_mfcc = n_mfcc  # feature dimension of mfcc
        self.mfcc_image = None
        self.mfcc_histogram = None

        # Record info of original file
        self.filename = filename
        self.original_length = len(self.data)

    def get_len_s(self):  # audio length in seconds
        return len(self.data) / self.sample_rate

    def compute_mfcc(self, n_mfcc=None):
        # https://librosa.github.io/librosa/generated/librosa.feature.mfcc.html
        # Check input
        if n_mfcc is None:
            n_mfcc = self.n_mfcc
        if self.n_mfcc is None:
            self.n_mfcc = n_mfcc

        # Compute
        self.mfcc = support_functions.compute_mfcc(self.data, self.sample_rate, n_mfcc)


class AudioDataset(Dataset):
    """A dataset class for Pytorch to load data"""

    def __init__(
        self,
        data_folder="",
        classes_txt="",
        file_paths=[],
        file_labels=[],
        transform=None,
        is_cache_audio=False,
        is_cache_XY=True,
    ):

        assert (data_folder and classes_txt) or (file_paths, file_labels)

        # Get all data's filename and label
        if not (file_paths and file_labels):
            file_paths, file_labels = AudioDataset.load_classes_and_data_filenames(
                classes_txt, data_folder
            )
        self._file_paths = file_paths
        self._file_labels = torch.tensor(file_labels, dtype=torch.int64)

        # Data augmentation methods are saved inside the `transform`
        self._transform = transform

        # Cache computed data
        self._IS_CACHE_AUDIO = is_cache_audio
        self._cached_audio = {}  # idx : audio
        self._IS_CACHE_XY = is_cache_XY
        self._cached_XY = {}  # idx : (X, Y). By default, features will be cached

    @staticmethod
    def load_classes_and_data_filenames(classes_txt, data_folder):
        """
        Load classes names and all training data's file_paths.
        Arguments:
            classes_txt {str}: filepath of the classes.txt
            data_folder {str}: path to the data folder.
                The folder should contain subfolders named as the class name.
                Each subfolder contain many .wav files.
        """
        # Load classes
        print(classes_txt, data_folder)
        print("========")
        with open(classes_txt, "r") as f:
            classes = [l.rstrip() for l in f.readlines()]

        # Based on classes, load all filenames from data_folder
        file_paths = []
        file_labels = []
        for i, label in enumerate(classes):
            folder = data_folder + "/" + label + "/"

            names = get_filenames(folder, file_types="*.wav")
            labels = [i] * len(names)

            file_paths.extend(names)
            file_labels.extend(labels)

        print("Load data from: ", data_folder)
        print("Classes: ", ", ".join(classes))
        return file_paths, file_labels

    def __len__(self):
        return len(self._file_paths)

    def get_audio(self, idx):
        """Load (idx)th audio, either from cached data, or from disk"""
        if idx in self.cached_audio:  # load from cached
            audio = copy.deepcopy(self.cached_audio[idx])  # copy from cache
        else:  # load from file
            filename = self._file_paths[idx]
            audio = AudioClass(filename=filename)
            # print(f"Load file: {filename}")
            self.cached_audio[idx] = copy.deepcopy(audio)  # cache a copy
        return audio

    def __getitem__(self, idx):

        # timer = support_functions.Timer()

        # -- Load audio
        if self._IS_CACHE_AUDIO:
            audio = self.get_audio(idx)
            print(
                "{:<20}, len={}, file={}".format(
                    "Load audio from file", audio.get_len_s(), audio.filename
                )
            )
        else:  # load audio from file
            if (idx in self._cached_XY) and (not self._transform):
                # if (1) audio has been processed, and (2) we don't need data augumentation,
                # then, we don't need audio data at all. Instead, we only need features from self._cached_XY
                pass
            else:
                filename = self._file_paths[idx]
                audio = AudioClass(filename=filename)

        # -- Compute features
        is_read_features_from_cache = (
            (self._IS_CACHE_XY) and (idx in self._cached_XY) and (not self._transform)
        )

        # Read features from cache:
        #   If already computed, and no augmentatation (transform), then read from cache
        if is_read_features_from_cache:
            X, Y = self._cached_XY[idx]

        # Compute features:
        #   if (1) not loaded, or (2) need new transform
        else:
            # Do transform (augmentation)
            if self._transform:
                audio = self._transform(audio)
                # self._transform(audio) # this is also good. Transform (Augment) is done in place.

            # Compute mfcc feature
            audio.compute_mfcc(n_mfcc=12)  # return mfcc

            # Compose X, Y
            X = torch.tensor(
                audio.mfcc.T, dtype=torch.float32
            )  # shape=(time_len, feature_dim)
            Y = self._file_labels[idx]

            # Cache
            if self._IS_CACHE_XY and (not self._transform):
                self._cached_XY[idx] = (X, Y)

        # print("{:>20}, len={:.3f}s, file={}".format("After transform", audio.get_len_s(), audio.filename))
        # timer.report_time(event="Load audio", prefix='\t')
        return (X, Y)
