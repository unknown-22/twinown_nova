class MastodonApi {
  final String clientId;
  final String clientSecret;

  String accessToken;

  MastodonApi(this.clientId, this.clientSecret) {
    // vZ-hYXIFm6WgSiP3YTYlb4RIqkd_zU4JTXSvQMRABYg
    // LB0VTbEoTOwjSW4SWR0eiz08GEIAupJI7SaZV5t3fFU
    // ufLn_WomlMv4P5eagHQhaygBmHBz2lllCjvtC5aGpcY
  }

  bool isClientAlreadyExits(){
    return false;
  }

  void getClient() {
  }

  void createClient() {
  }

  List<String> getHome() {
    return [];
  }
}
