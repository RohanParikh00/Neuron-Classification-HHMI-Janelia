#Experimental trial files metadata information

Note: 
- (features included) is a list of features with a length equal to feature_size
- Feature selection was informed by recursive feature elimination
-   Top 3 features: full amplitude, negative amplitude, positive amplitude
-   Top 4 features: full amplitude, negative amplitude, positive amplitude, regularity
-   Top 5 features: full amplitude, negative amplitude, positive amplitude, regularity, interspike interval
-   8 features: all calculated features
-   29 features: points of raw waveform
-   37 features: combined calculated and raw features

Multilayer Perceptron Network (MPN) & Convolutional Neural Network (CNN):
experiment number, trials, learning rate, training epochs, feature size, (features included)

Random Forests (RF):
number of trees, max features, feature size, (features included)

Gradient Tree Boosting (GTB):
number of trees, feature size, (features included)

K-means Clustering (K-means):
number of clusters, n_init, max iterations, feature size, (features included)

K-nearest Neighbors (KNN): 
number of neighbors, feature size, (features included)

t-distributed Stochastic Neighbor Embedding (TSNE):
perpexity, learning rate, number of iterations, feature size, (features included)

Extra Trees Classifier (ET):
number of trees, feature size, (features included)

Logistic Regression Classifier (LR):
relative regularization strength, feature size, (features included)
