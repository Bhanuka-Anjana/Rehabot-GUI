# import torch
import numpy as np

import voicecomand.training.arguments as arguments
import voicecomand.training.RNN as RNN

classes = 0
model = 0


def setup_default_RNN_model(weight_filepath, classes_txt):
    """Given filepath of the weight file and the classes,
    Initilize the RNN model with default parameters.
    """
    # device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
    model_args = arguments.set_default_args()
    model_args.classes_txt = classes_txt
    model = RNN.create_RNN_model(model_args, weight_filepath)
    classes = model.classes
    if 0:  # Test with random data
        label_index = model.predict(np.random.random((66, 12)))
        print("Label index of a random feature: ", label_index)
        exit("Complete test.")
    return model, classes


def init_model(src_weight_path, src_classes_path):
    # Init model
    # global classes, model
    model, classes = setup_default_RNN_model(src_weight_path, src_classes_path)
    print("Number of classes = {}, classes: {}".format(len(classes), classes))
    model.set_classes(classes)
    return model, classes


def load_model(model_path):
    src_weight_path = model_path
    src_classes_path = "classes/classes.names"
    global classes, model
    model, classes = init_model(src_weight_path, src_classes_path)
