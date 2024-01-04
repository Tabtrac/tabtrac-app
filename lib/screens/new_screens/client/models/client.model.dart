class GetClients {
  final String response;
  final List<Client> clients;

  GetClients({required this.response, required this.clients});

  factory GetClients.fromJson(Map<String, dynamic> json) {
    return GetClients(
      response: json['response'],
      clients: (json['client'] as List)
          .map((clientJson) => Client.fromJson(clientJson))
          .toList(),
    );
  }
}

class Client {
  final int id;
  final String name;
  final String? location;
  final String? email;
  final String? phoneNumber;
  final String dateCreated;
  final String user;

  Client({
    required this.id,
    required this.name,
    this.location,
    this.email,
    this.phoneNumber,
    required this.dateCreated,
    required this.user,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      dateCreated: json['date_created'],
      user: json['user'],
    );
  }
}
