class Verify {
  String status;

  Verify(this.status);

  Verify.fromJSON(Map<String, dynamic> json)
      : status = json["status"];

  Map<String, dynamic> toJSON() => {
        'status': status
      };
}