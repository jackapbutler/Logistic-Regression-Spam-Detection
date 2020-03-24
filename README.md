# Logistic-Regression-Spam-Detection
I fitted a Logistic Regression model to the spam dataset found in R. This initial fit used only the variables related to character frequency and occurence of special characters. The initial model showed a clear seperation between the two classes as seen below and all predictor variables were significant.

![Image of framework](https://github.com/jackapbutler/Logistic-Regression-Spam-Detection/blob/master/Elements/distribution_of_classifications.PNG)

I then examined the model accuracy using a ROC Curve. ROC is a probability curve and AUC (Area under the curve) represents degree or measure of separability. A higher AUC, close to 1, indicates the model is better at distinguishing between spam or non-spam emails.
![Image of framework](https://github.com/jackapbutler/Logistic-Regression-Spam-Detection/blob/master/Elements/ROC.PNG)
We can see from the above plot the curve rises sharply to the top left before smoothing out. To achieve an
approximately 80% true positive rate the model has a corresponding 10% false positive rate. The area under
the curve for our ﬁnal model is equal to 0.90204.

The threshold value, in this context, determines the probability with which the model will classify an email
as spam. For example, if this threshold is set to 0.5, all emails with a predicted probability of spam higher
than 0.5 will be classiﬁed as spam. The statistically optimal threshold is the value that maximises the sum of Sensitivity and Speciﬁcity.
![Image of framework](https://github.com/jackapbutler/Logistic-Regression-Spam-Detection/blob/master/Elements/threshold_max.PNG)
However, I calculated at this threshold the Sensitivity (true positive rate) is equal to 0.87 and the false positive rate for this threshold value is 0.17. This means that 17% of non-spam emails are being incorrectly classiﬁed as spam. With a new threshold value of 0.52 we see a reduction to the False Positive Rate of approximately 41% to 10% while maintaining a True Positive Rate (Sensitivity) of 81%.  

For spam email prediction it is essential that very few non-spam emails are incorrectly classiﬁed as spam because vital corporate or personal information could be lost. It is less important for the user to see a few extra actual spam emails in their inbox.

