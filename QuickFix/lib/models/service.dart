class Service {
  final String name;
  final String imageURL;

  Service(this.name, this.imageURL);

  String get image => imageURL;
}
