import time

import librosa
import numpy as np
import sklearn
import soundfile as sf


class Timer(object):
    """
    Timer calculate the time cost.
    timer start when initilaze Timer class.
    timer stop after call report_time().
    """

    def __init__(self):
        self.t0 = time.time()

    def report_time(self, event="", prefix=""):
        print(
            prefix
            + "Time cost of '{}' is: {:.2f} seconds.".format(
                event, time.time() - self.t0
            )
        )


def read_list(filename):
    with open(filename) as f:
        with open(filename, "r") as f:
            data = [l.rstrip() for l in f.readlines()]
    return data


def read_audio(filename, dst_sample_rate=16000, is_print=False):
    if (
        0
    ):  # This takes 0.4 seconds to read an audio of 1 second. But support for more format
        data, sample_rate = librosa.load(filename)
    else:  # This only takes 0.01 seconds
        data, sample_rate = sf.read(filename)

    assert len(data.shape) == 1, "This project only support 1 dim audio."

    if (dst_sample_rate is not None) and (dst_sample_rate != sample_rate):
        data = librosa.core.resample(data, sample_rate, dst_sample_rate)
        sample_rate = dst_sample_rate

    if is_print:
        print(
            "Read audio file: {}.\n Audio len = {:.2}s, sample rate = {}, num points = {}".format(
                filename, data.size / sample_rate, sample_rate, data.size
            )
        )
    return data, sample_rate


def compute_mfcc(data, sample_rate, n_mfcc=12):
    # Extract MFCC features
    # https://librosa.github.io/librosa/generated/librosa.feature.mfcc.html
    mfcc = librosa.feature.mfcc(
        y=data,
        sr=sample_rate,
        n_mfcc=n_mfcc,
    )
    # https://dsp.stackexchange.com/questions/28898/mfcc-significance-of-number-of-features
    # How many mfcc features to use? 12 at most.
    return mfcc


def split_train_test(
    X, Y, test_size=0, use_all_data_to_train=False, dtype="numpy", if_print=True
):
    assert dtype in ["numpy", "list"]

    def _print(s):
        if if_print:
            print(s)

    _print("split_train_test:")

    if dtype == "numpy":
        _print(
            "\tData size = {}, feature dimension = {}".format(X.shape[0], X.shape[1])
        )
        if use_all_data_to_train:
            tr_X = np.copy(X)
            tr_Y = np.copy(Y)
            te_X = np.copy(X)
            te_Y = np.copy(Y)
        else:
            f = sklearn.model_selection.train_test_split
            tr_X, te_X, tr_Y, te_Y = f(X, Y, test_size=test_size, random_state=0)

    elif dtype == "list":
        _print("\tData size = {}, feature dimension = {}".format(len(X), len(X[0])))

        if use_all_data_to_train:
            tr_X = X[:]
            tr_Y = Y[:]
            te_X = X[:]
            te_Y = Y[:]
        else:
            N = len(Y)
            train_size = int((1 - test_size) * N)
            randidx = np.random.permutation(N)
            n1, n2 = randidx[0:train_size], randidx[train_size:]

            def get(arr_vals, arr_idx):
                return [arr_vals[idx] for idx in arr_idx]

            tr_X = get(X, n1)[:]
            tr_Y = get(Y, n1)[:]
            te_X = get(X, n2)[:]
            te_Y = get(Y, n2)[:]
    _print("\tNum training: {}".format(len(tr_Y)))
    _print("\tNum evaluation: {}".format(len(te_Y)))
    return tr_X, tr_Y, te_X, te_Y


def split_train_eval_test(X, Y, ratios=[0.8, 0.1, 0.1], dtype="list"):
    X1, Y1, X2, Y2 = split_train_test(X, Y, 1 - ratios[0], dtype=dtype, if_print=False)

    X2, Y2, X3, Y3 = split_train_test(
        X2, Y2, ratios[2] / (ratios[1] + ratios[2]), dtype=dtype, if_print=False
    )

    r1, r2, r3 = 100 * ratios[0], 100 * ratios[1], 100 * ratios[2]
    n1, n2, n3 = len(Y1), len(Y2), len(Y3)
    print(
        "Split data into [Train={} ({}%), Eval={} ({}%),  Test={} ({}%)]".format(
            (n1), (r1), (n2), (r2), (n3), (r3)
        )
    )
    tr_X, tr_Y, ev_X, ev_Y, te_X, te_Y = X1, Y1, X2, Y2, X3, Y3
    return tr_X, tr_Y, ev_X, ev_Y, te_X, te_Y


# timer=Timer()
# time.sleep(2)
# timer.report_time(event="Load audio", prefix='\t')
