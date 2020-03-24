# Logistic-Regression-Spam-Detection
I fitted a Logistic Regression model to the spam dataset found in R. This initial fit used only the variables related to character frequency and occurence of special characters. The initial model showed a clear seperation between the two classes as seen below and all predictor variables were significant.

![Image of framework](https://github.com/jackapbutler/Logistic-Regression-Spam-Detection/blob/master/Elements/distribution_of_classifications.PNG)

I then examined the model accuracy using a ROC Curve. ROC is a probability curve and AUC (Area under the curve) represents degree or measure of separability. A higher AUC, close to 1, indicates the model is better at distinguishing between spam or non-spam emails.
![Image of framework](https://github.com/jackapbutler/Logistic-Regression-Spam-Detection/blob/master/Elements/ROC.PNG)
We can see from the above plot the curve rises sharply to the top left before smoothing out. To achieve an
approximately 80% true positive rate the model has a corresponding 10% false positive rate. The area under
the curve for our ﬁnal model is equal to 0.90204.

