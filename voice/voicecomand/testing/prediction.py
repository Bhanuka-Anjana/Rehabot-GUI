import numpy as np

import voicecomand.testing.model as model_functions
import voicecomand.training.audioprocess as audioprocess


def predict_by_file(file):
    filename = file
    # filename = 'testing_data/' + file

    audio = audioprocess.AudioClass(filename=filename)

    probs = model_functions.model.predict_audio_label_probabilities(audio)
    # print(probs,model_functions.classes)
    predicted_idx = np.argmax(probs)
    predicted_label = model_functions.classes[predicted_idx]
    max_prob = probs[predicted_idx]
    # print("\nAll word labels: {}".format(classes))
    # print("\nPredicted label: {}, probability: {}\n".format(
    #     predicted_label, max_prob))
    PROB_THRESHOLD = 0.8
    final_label = predicted_label if max_prob > PROB_THRESHOLD else "none"
    return final_label, max_prob, probs, model_functions.classes
