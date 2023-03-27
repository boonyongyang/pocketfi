import 'package:flutter/foundation.dart' show immutable;

@immutable
class Strings {
  static const appName = 'PocketFi!';
  static const welcomeToAppName = 'Welcome to ${Strings.appName}';
  static const youHaveNoPosts =
      'You have not made a post yet. Press either the video-upload or the photo-upload buttons to the top of the screen in order to upload your first post!';
  static const noPostsAvailable =
      "Nobody seems to have made any posts yet. Why don't you take the first step and upload your first post?!";
  static const enterYourSearchTerm =
      'Enter your search term in order go get started. You can search in the description of all posts available in the system';

  // static const facebook = 'Facebook';
  // static const facebookSignupUrl = 'https://www.facebook.com/signup';
  static const google = 'Google';
  static const googleSignupUrl = 'https://accounts.google.com/signup';
  static const logIntoYourAccount =
      'Log into your account using one of the options below.';
  static const comments = 'Comments';
  static const writeYourCommentHere = 'Write your comment here...';
  static const checkOutThisPost = 'Check out this post!';
  static const postDetails = 'Post Details';
  static const post = 'post';

  static const createNewPost = 'Create New Post';
  static const pleaseWriteYourMessageHere = 'Please write your message here';

  static const noCommentsYet =
      'Nobody has commented on this post yet. You can change that though, and be the first person who comments!';

  static const enterYourSearchTermHere = 'Enter your search term here';

  static const dontHaveAnAccount = "Don't have an account?\n";
  static const signUpOn = 'Sign up on ';
  // static const orCreateAnAccountOn = ' or create an account on ';

  // * general
  static const loading = 'Loading...';

  static const delete = 'Delete';
  static const areYouSureYouWantToDeleteThis =
      'Are you sure you want to delete this';

  static const logOut = 'Log out';
  static const areYouSureThatYouWantToLogOutOfTheApp =
      'Are you sure that you want to log out of the app?';
  static const cancel = 'Cancel';

  // * authentication
  static const accountExistsWithDifferentCredential =
      'account-exists-with-different-credential';
  static const googleCom = 'google.com';
  static const emailScope = 'email';

  // * timeline
  static const timeline = 'Timeline';

  // transaction
  static const transaction = 'Transaction';
  static const expenseSymbol = '-';
  static const incomeSymbol = '+';
  static const transferSymbol = '⇄';
  static const selectCategory = 'Select Category';
  static const selectPhoto = 'Select photo';
  static const writeANote = 'Write a note';
  static const newTransaction = 'New Transaction';
  static const editTransaction = 'Edit Transaction';
  static const zeroAmount = '0';
  static const expense = 'Expense';
  static const income = 'Income';
  static const transfer = 'Transfer';
  static const save = 'Save';

  // dates
  static const today = 'Today';
  static const yesterday = 'Yesterday';
  static const tomorrow = 'Tomorrow';

  // receipt
  static const scanReceiptFrom = 'Scan Receipt from';
  static const camera = 'Camera';
  static const gallery = 'Gallery';

  // bills
  static const bill = 'Bill';
  static const bills = 'Bills';
  static const newBill = 'New Bill';
  static const editBill = 'Edit Bill';
  static const paid = 'Paid';
  static const unpaid = 'Unpaid';
  static const overdue = 'Overdue';

  // * budget
  static const budget = 'Budget';
  static const total = 'Total';
  static const createNewBudget = 'Create New Budget';
  static const budgetName = 'Budget Name';
  static const noBudgetsYet = 'No budgets available yet';
  static const amount = "Amount";
  static const currency = 'Currency';
  static const createNewWallet = 'Create New Wallet';
  static const wallet = 'Wallet';
  static const walletName = 'Wallet Name';
  static const walletBalance = 'Wallet Balance';
  static const noWalletsYet = 'No wallets available yet';
  static const saveChanges = 'Save Changes';

  // * finances
  static const finances = 'Finances';

  // * debt
  static const debt = 'Debt';
  static const addDebt = 'Add Debt';

  // * saving goals
  static const savingGoals = 'Saving Goals';
  static const createNewSavingGoal = 'Create New Saving Goal';
  static const savingGoalName = 'Saving Goal Name';
  static const noSavingGoalsYet = 'No saving goals available yet';

  // * account
  static const account = 'Account';

  // * categories
  static const categories = 'Categories';

  const Strings._();
}
