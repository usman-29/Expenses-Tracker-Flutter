import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
  // create credentials
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "expenses-sheet-366805",
  "private_key_id": "29eff80df87ddad7b78d5a06c48c87196dab92ea",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC1Mqlokzx4VS3H\nBzrSxUvG3sYZyLwS6a0tbvmDvv72yvTUafbJeiLtZOmPSKgnMgUOxZvaOg0vR6Yl\n11aXovsfS7P28VRr+cmv4z9nLBQhPvsOfArkeslbjKhs4LeuAGZ0H+nRrKjthK0E\nqMbmJnCoqHdmKFLYjSXsyq11K/v65+j4SipGQsHMA48aQQmTfNy0CuPMxYd88ErT\nPdLBSMHERpvUn8W8Sdwe9AD9CaT1ILroKFEdOiroPZXVSyf3jNECRQF0B2S+QIpH\nr5bnNCpOkBJMKe+U3ibA5Ng+17CPvem29B2i9alu4nSjOKCg3L7IcNg/PnnBRzqk\nLPgAEwWzAgMBAAECggEAEWnNJQXNUGUjMUGCciylaSG8mPq/tEjtAcpB7rAlZt3p\n+cXggnabMlmPJobIKNLM8KFQpoALXKlT5XFp2shovhZeNP5L63/bAEJkXqEPothK\nHpdmIT9O6DOUILksfcDVF8DUuCKR2ML2MQCanhXrSry8k2k5o6JWQYjYHZlnWF0q\nvHi3WQUgq8OmP/XG+cbjaUtJ2JmmQsLwoQD9/X14sIsHd89IWFadHI7Lh8fY8yLK\nZZOPvmpJnNZ6g6FhxnsyBtvmqwiFE2ymQ+O4mXR3jU1RuD7tC92JNkEH/diUqzcc\nJCxVfB4hnK49fZzmHclhxxobYuQK3pHP3cSZQ2R3MQKBgQDaW4g+OWAsgB/zNDA3\nyuu4cH0x8w/Z8YJYpxz5QaDPgz5dMjlya4ctqGJ3mC1lxGprcK5tOADK7pvFpncG\nin8UBYzbTZfFL6l3wYvcohOMBHsbzjRpaMH3EpZCEWpwtLay7xZ1T/iSB7oR7dbW\nYu1D0tr/g9ovpcpy7PrUlGTLQwKBgQDUbzb6f1cvJhaQ3YySM/YREH45ErlEalrt\ngc6G0S5yJEQHX/kFIiB0oSEjWOUUAPg0SUTtk7nin0p9XFm2kj1nKof5iUZGOXd3\n9NP3MT3ewftCen3NAD+4z6zDDnN0SN1cRcpdPPCYxNWN2PPPl841VQPZyfWxUYbU\nSuMiI/9c0QKBgQCzhZeA2Pkp/PjHofuWkz2zeMBlZZl9rKJmspYOk5dbpGKMirNS\nT/dmYU77VmDUj2STCqRNZUK5lOz61f57oTgTRPDmiGekFah1remILrR1ZGW2mZTb\nqOX3dQ+WJ+1j1h9zA0BqmKIbpUCkZu8/eTvqjBvDAStMCzljvVQHnC02MwKBgApE\nAZUjWDQ4E/kWK7fY+PgkIuVhKUDMHu7BShirvSHY7Myqb5824fig3LgXkKJh1Zy5\nObJ9ZAs2hWP/dXpkIMF+hamiX5n/Ju3OD/wvDf1YxGqW/sNMUsf8iS234g5pgwD1\ngmz1B+9p+6PqKwYKIPXk0NXSc6QI+4oAwG8i7DExAoGAIVLvarjyBFWiSyNwELiZ\ntbq+IME4IukR/4WGf6voq8LPMe13AbqJNN1mVIJnydSKslTOTX4IWUg09v6wkTGo\nemRBItSfKwnSLXxYhM26s4HktlGPuKDuu7TWvXv96g+HzaXnX/Dmb01WHwOvJh+X\n7ynzEEW53lQ3BY8+XOoWZec=\n-----END PRIVATE KEY-----\n",
  "client_email": "expensessheets@expenses-sheet-366805.iam.gserviceaccount.com",
  "client_id": "101148265363026098381",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/expensessheets%40expenses-sheet-366805.iam.gserviceaccount.com"
  }
  ''';

  // set up & connect to the spreadsheet
  static const _spreadsheetId = '1Z5gs_U_A6lwHx3FKS8BEGXNLmsMqoE-soO_R41XWLzg';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  // some variables to keep track of..
  static int numberOfTransactions = 0;
  static List<List<dynamic>> currentTransactions = [];
  static bool loading = true;

  // initialize the spreadsheet!
  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('Sheet1');
    countRows();
  }

  // count the number of notes
  static Future countRows() async {
    while ((await _worksheet!.values
            .value(column: 1, row: numberOfTransactions + 1)) !=
        '') {
      numberOfTransactions++;
    }
    // now we know how many notes to load, now let's load them!
    loadTransactions();
  }

  // load existing notes from the spreadsheet
  static Future loadTransactions() async {
    if (_worksheet == null) return;

    for (int i = 1; i < numberOfTransactions; i++) {
      final String transactionName =
          await _worksheet!.values.value(column: 1, row: i + 1);
      final String transactionAmount =
          await _worksheet!.values.value(column: 2, row: i + 1);
      final String transactionType =
          await _worksheet!.values.value(column: 3, row: i + 1);

      if (currentTransactions.length < numberOfTransactions) {
        currentTransactions.add([
          transactionName,
          transactionAmount,
          transactionType,
        ]);
      }
    }
    // this will stop the circular loading indicator
    loading = false;
  }

  // insert a new transaction
  static Future insert(String name, String amount, bool isIncome) async {
    if (_worksheet == null) return;
    numberOfTransactions++;
    currentTransactions.add([
      name,
      amount,
      isIncome == true ? 'income' : 'expense',
    ]);
    await _worksheet!.values.appendRow([
      name,
      amount,
      isIncome == true ? 'income' : 'expense',
    ]);
  }

  // CALCULATE THE TOTAL INCOME!
  static double calculateIncome() {
    double totalIncome = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'income') {
        totalIncome += double.parse(currentTransactions[i][1]);
      }
    }
    return totalIncome;
  }

  // CALCULATE THE TOTAL EXPENSE!
  static double calculateExpense() {
    double totalExpense = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'expense') {
        totalExpense += double.parse(currentTransactions[i][1]);
      }
    }
    return totalExpense;
  }
}
