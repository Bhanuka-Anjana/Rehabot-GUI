import torch


class Arguments:
    """Default Arguments class"""

    def __init__(self, **kwargs):
        self.__dict__.update(kwargs)

    def __repr__(self):
        keys = sorted(self.__dict__)
        items = ("{}={!r}".format(k, self.__dict__[k]) for k in keys)
        return "{}({})".format(type(self).__name__, ", ".join(items))

    def __eq__(self, other):
        return self.__dict__ == other.__dict__


def set_default_args():
    args = Arguments()

    # model params
    args.input_size = 12  # == n_mfcc
    args.batch_size = 1
    args.hidden_size = 64
    args.num_layers = 3

    # training params

    args.learning_rate_decay_interval = 5  # decay for every 5 epochs
    args.learning_rate_decay_rate = 0.5  # lr = lr * rate
    args.weight_decay = 0.00
    args.gradient_accumulations = 16  # number of gradient accums before step

    args.num_epochs = 20
    args.learning_rate = 0.001
    args.train_eval_test_ratio = [0.8, 0.2, 0.0]
    args.do_data_augment = False
    args.data_folder = "training_data/"
    args.classes_txt = "classes/classes.names"
    args.load_weight_from = "model/020.ckpt"
    args.finetune_model = True  # If true, fix all parameters except the fc layer
    args.save_model_to = "checkpoints/"  # Save model and log file
    args.temp_audio_folder = "temp_voice/"

    # training params2
    args.device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

    args.num_classes = None  # should be added with a value somewhere, like this:
    #                = len(lib_io.read_list(args.classes_txt))

    # log setting
    args.plot_accu = True  # if true, plot accuracy for every epoch
    args.show_plotted_accu = (
        False  # if false, not calling plt.show(), so drawing figure in background
    )
    args.save_model_to = "checkpoints/"  # Save model and log file
    # e.g: model_001.ckpt, log.txt, log.jpg

    return args
