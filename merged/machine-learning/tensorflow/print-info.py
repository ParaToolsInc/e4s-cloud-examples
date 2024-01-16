#!/usr/bin/env python3

import tensorflow

print("TensorFlow Version:", tensorflow.__version__)
print("Devices:")
for gpu in tensorflow.config.list_physical_devices('GPU'):
  print(gpu)
