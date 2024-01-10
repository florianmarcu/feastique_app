class MenuItem{
  String title;
  String content;
  List<dynamic> ingredients;
  List<dynamic> alergens;
  String price;

  MenuItem({required this.title, required this.content, required this.ingredients, required this.alergens, required this.price});
}

MenuItem menuItemDataToMenuItem(Map<String, dynamic> data){
  return MenuItem(
    title: data["title"],
    content: data["content"],
    ingredients: data["ingredients"],
    alergens: data["alergens"],
    price: data['price']
  );
}