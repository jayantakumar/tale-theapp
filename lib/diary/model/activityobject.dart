//the very important Activity object itself
//this is the class that has activity object very important file

class ActivityObject {
  //properties
  String _activityName;
  String _activityEmoji;
  String _activityType;

  //constructors
  ActivityObject(this._activityName, this._activityEmoji, this._activityType);
  ActivityObject.fromMap(Map map) {
    this._activityEmoji = map["emoji"];
    this._activityName = map["name"];
  }

  //getters
  String get activity => _activityName;
  String get emoji => _activityEmoji;
  String get type => _activityType;
}

//the list of all such activity objects
class Server {
  List<ActivityObject> _activityList = [
    //entertainment
    ActivityObject("Movies", "🎬", "Entertainment"),
    ActivityObject("Games", "🕹", "Entertainment"),
    ActivityObject("Music", "🎧", "Entertainment"),
    //other
    ActivityObject("Spacy", "🛰️", "Other"),
    ActivityObject("Flying", "🚁", "Other"),
    //food
    ActivityObject("Healthy Food", "🍎", "Food"),
    ActivityObject("Junk Food", "🍟", "Food"),
    ActivityObject("Beer", "🍺", "Food"),
    ActivityObject("Breakfest", "🍞", "Food"),
    ActivityObject("Meaty", "🍗", "Food"),
    ActivityObject("Sweets", "🍭", "Food"),
    //games
    ActivityObject("Soccer", "⚽", "Games"),
    ActivityObject("Baseball", "⚾", "Games"),
    ActivityObject("FootBall", "🏈", "Games"),
    ActivityObject("Baskety", "🏀", "Games"),
    ActivityObject("Tennis", "🎾", "Games"),
    ActivityObject("Cricket", "🏏", "Games"),
    ActivityObject("Fishing", "🎣", "Games"),
    ActivityObject("Victory", "🏆", "Games"),
    //travel and places
    ActivityObject("Driving", "🚗", "Travel"),
    ActivityObject("Flight", "✈", "Travel"),
    ActivityObject("Fuel", "⛽", "Travel"),
    ActivityObject("Travel", "🗺", "Travel"),
    ActivityObject("Holidays", "🏝", "Travel"),
    ActivityObject("Hospital", "🏥", "Travel"),
    ActivityObject("Beach", "🏖", "Travel"),
    ActivityObject("Carnival", "🎆", "Travel"),
    ActivityObject("Camping", "🏕️", "Travel"),

    //nature
    ActivityObject("Doggy", "🐕", "Nature"),
    ActivityObject("Cat", "🐱", "Nature"),
    ActivityObject("Turkey", "🦃", "Nature"),
    ActivityObject("Rooster", "🐓", "Nature"),
    ActivityObject("Butterfly", "🦋", "Nature"),
    ActivityObject("Spidey", "🕷", "Nature"),
    ActivityObject("Tree", "🌲", "Nature"),
    ActivityObject("Flower", "🌹", "Nature"),
    ActivityObject("Palmy", "🌴", "Nature"),
    ActivityObject("Sapling", "🌱", "Nature"),
    ActivityObject("Blossoming", "🌼", "Nature"),
    ActivityObject("Leaf", "🍃", "Nature"),
    ActivityObject("Snake", "🐍", "Nature"),
    ActivityObject("Octopus", "🐙 ", "Nature"),
    ActivityObject("Crab", "🦀", "Nature"),
    ActivityObject("Web", "🕸", "Nature"),
    ActivityObject("Scorpian", "🦂", "Nature"),
    ActivityObject("Bee", "🐝", "Nature"),
    ActivityObject("Rainbow", "🌈", "Nature"),
    ActivityObject("Sun", "☀", "Nature"),
    ActivityObject("Rain", "☔", "Nature"),
    ActivityObject("Wintry Showers", "🌨", "Nature"),
    //objects
    ActivityObject("Money", "💰", "Objects"),
    ActivityObject("Gift", "🎁", "Objects"),
    ActivityObject("Books", "📗", "Objects"),
    //events
    ActivityObject("Shopping", "🛒", "Events"),
    //feeling
    ActivityObject("Hot", "🔥", "Feeling"),
    ActivityObject("Lovely", "💖", "Feeling"),
    ActivityObject("Broken", "💔", "Feeling"),
    ActivityObject("Lovely", "💖", "Feeling"),
    //people
    ActivityObject("Love", "💑", "People"),
    ActivityObject("Family", "👪", "People"),
    ActivityObject("Boy", "👦", "People"),
    ActivityObject("Girl", "👧", "People"),
    ActivityObject("Granny", "👵", "People"),
    ActivityObject("Grandpa", "👴", "People"),
    ActivityObject("Baby", "👶", "People"),
    ActivityObject("Friend", "👬", "People"),
  ];
  //getter function
  List<ActivityObject> get activityList => _activityList;

  //gets the objects in the list which matches the given type
  List<ActivityObject> getActivityListByType(String type) => type != "All"
      ? _activityList.where((e) => e.type == type).toList()
      : _activityList;

  //adds a given Activity object to the list
  void addActivityObject(ActivityObject obj) => _activityList.add(obj);

  //removes the given activity object from the list
  void removeActivityObjectWithName(String name) =>
      _activityList.removeWhere((o) => o.activity == name);

  //constructs a list of GridItemModel for a given activityList and returns it back
  List<GridItemModel> getGridList(List<ActivityObject> obj) {
    List<GridItemModel> list = [];
    for (int i = 0; i < obj.length; i++)
      list.add(GridItemModel(i, false, obj[i]));
    return list;
  }
}

//the grid item model class

class GridItemModel {
  final int index;
  final ActivityObject obj;
  bool isSelected;
  GridItemModel(this.index, this.isSelected, this.obj);
}
