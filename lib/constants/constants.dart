import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color lightScaffoldBackgroundColor = Color(0xffF2F1F7);
Color lightCardColor = Color(0xffF2F1F7);
Color lightTextColor = Color(0xff434055);

Color darkScaffoldBackgroundColor = Color(0xff24232D);
Color darkCardColor = Color(0xff24232D);
Color darkTextColor = Color(0xff62635F);

dynamic darkLogo = TextStyle(
  fontFamily: 'logo',
  color: darkCardColor,
  fontSize: 30.0,
);
dynamic lightLogo = TextStyle(
  fontFamily: 'logo',
  color: lightCardColor,
  fontSize: 30.0,
);
dynamic lightText =
    GoogleFonts.roboto(color: Colors.grey.shade100, fontSize: 16);
dynamic darkText = GoogleFonts.roboto(color: lightTextColor, fontSize: 16);

final List<String> randomQuestions = [
  "What are some common backend programming languages?",
  "What is a RESTful API?",
  "What is a database index?",
  "What is the difference between SQL and NoSQL databases?",
  "What is the role of a server in backend development?",
  "What is the difference between synchronous and asynchronous programming?",
  "What is the difference between stateful and stateless servers?",
  "What are some popular deep learning frameworks?",
  "What is the difference between supervised and unsupervised learning?",
  "What is the curse of dimensionality?",
  "What is a neural network?",
  "What is the difference between regression and classification?",
  "What is a decision tree?",
  "What is cross-validation?",
  "What is an activation function?",
  "What is backpropagation?",
  "What is the role of regularization in machine learning?",
  "What is gradient descent?",
  "What is the difference between clustering and classification?",
  "What is the difference between overfitting and underfitting?",
  "What is the difference between reinforcement learning and supervised learning?",
  "What is Bayes' theorem?",
  "What is the Markov property?",
  "What is the difference between precision and recall?",
  "What is a convolutional neural network?",
  "What is a recurrent neural network?",
  "What is a generative adversarial network?",
  "What is transfer learning?",
  "What is principal component analysis?",
  "What is k-means clustering?",
  "What is a support vector machine?",
  "What is a random forest?",
  "What is an ensemble model?",
  "What is the law of large numbers?",
  "What is the central limit theorem?",
  "What is a normal distribution?",
  "What is the difference between variance and standard deviation?",
  "What is a correlation coefficient?",
  "What is a hypothesis test?",
  "What is the difference between a sample and a population?",
  "What is a statistical significance?",
  "What is a p-value?",
  "What is the difference between correlation and causation?",
  "What is time series analysis?",
  "What is a moving average?",
  "What is autocorrelation?",
  "What is a Fourier transform?",
  "What is a stationary process?",
  "What is a stock market index?",
  "What is the difference between a bull and a bear market?",
  "What is a stock market bubble?",
  "What is insider trading?",
  "What is a dividend?",
  "What is a stock option?",
  "What is a stock split?",
  "What is a margin call?",
  "What is short selling?",
  "What is a stop-loss order?",
  "What is technical analysis?",
  "What is fundamental analysis?",
  "What is a price-to-earnings ratio?",
  "What is a market capitalization?",
  "What is a beta coefficient?",
  "What is the efficient market hypothesis?",
  "What is the risk-return tradeoff?",
  "What is portfolio diversification?",
  "What is the difference between a mutual fund and an exchange-traded fund?",
  "What is a hedge fund?",
  "What is a derivative?",
  "What is a futures contract?",
  "What is an option contract?"
];


// josefinSans