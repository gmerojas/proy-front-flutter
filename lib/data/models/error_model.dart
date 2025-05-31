class ErrorModel {
  final int code;
  final String message;

  ErrorModel({
    required this.code, 
    required this.message
  });

  factory ErrorModel.fromJson(Map<String,dynamic> json){
    return ErrorModel(
      code: json['code'], 
      message: json['message']
    );
  }

  Map<String,dynamic> toJson() => {
    "code": code,
    "message": message
  };
}