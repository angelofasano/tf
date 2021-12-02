class BarIndexService {
  static final BarIndexService _instance = BarIndexService._internal();

  // passes the instantiation to the _instance object
  factory BarIndexService() => _instance;

  //initialize variables in here
  BarIndexService._internal() {
    _index = 0;
  }

  int _index = 0;
  int get index => _index;
  set index(int value) => index = value;
  update(int index) {
    _index = index;
  }
}
