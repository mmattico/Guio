class Autogenerated {
  List<Instrucciones> instrucciones = [];

  Autogenerated({required this.instrucciones});

  Autogenerated.fromJson(Map<String, dynamic> json) {
    if (json['instrucciones'] != null) {
      instrucciones = <Instrucciones>[];
      json['instrucciones'].forEach((v) {
        instrucciones.add(new Instrucciones.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['instrucciones'] =
        this.instrucciones.map((v) => v.toJson()).toList();
      return data;
  }
}

class Instrucciones {
  String? commando;
  String? siguienteNodo;
  int? distancia;
  bool? existePuerta;
  bool? haygiro;
  String? sentido;

  Instrucciones(
      {this.commando,
        this.siguienteNodo,
        this.distancia,
        this.existePuerta,
        this.haygiro,
        this.sentido});

  String instruccionToString(){
    String retorna="";
    if(this.commando!=""){
      retorna = this.commando!;
    }else{
      if(this.distancia! > 0){
        retorna = "Tiene que avanzar " + this.distancia.toString() + " metros.";
        retorna += " El siguiente nodo es: " + this.siguienteNodo! + ".";
        if(this.existePuerta == true){
          retorna += "Hay una puerta en el camino.";
        }
      }else{
        if(this.haygiro == true){
          retorna += "Gire hacia la " + this.sentido.toString() + ".";
        }
      }
    }
    return retorna;
  }

  Instrucciones.fromJson(Map<String, dynamic> json) {
    commando = json['commando'];
    siguienteNodo = json['siguienteNodo'];
    distancia = json['distancia'];
    existePuerta = json['existePuerta'];
    haygiro = json['haygiro'];
    sentido = json['sentido'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commando'] = this.commando;
    data['siguienteNodo'] = this.siguienteNodo;
    data['distancia'] = this.distancia;
    data['existePuerta'] = this.existePuerta;
    data['haygiro'] = this.haygiro;
    data['sentido'] = this.sentido;
    return data;
  }
}