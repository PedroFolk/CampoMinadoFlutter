import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/buttons.dart';
import 'package:flutter_application_1/components/campo_tile.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

int numCol = 9;
int numQuadrado = numCol * numCol;
int numBombas = 2;

List<int> localBombas = [];

var squareStatus = [];
var flagStatus = [];

class _GamePageState extends State<GamePage> {
  @override
  void initState() {
    super.initState();

    //Identifica todos os quadrados como falso quando inicia
    for (int i = 0; i < numQuadrado; i++) {
      squareStatus.add([0, false]);
      flagStatus.add([false]);
    }

    geraNumeros();
  }

  //Gera 10 numeros aleatorio e adiciona na lista localBombas
  void geraNumeros() {
    localBombas.clear();
    while (localBombas.length < numBombas) {
      int randNum = Random().nextInt(numQuadrado);
      if (!localBombas.contains(randNum)) {
        localBombas.add(randNum);
      }
    }
    print(localBombas.toString());
    scanBomb();
  }

  //Ajusta o tamanho ao clicar no botão
  void tamanho(int tam) {
    numCol = tam;
    numQuadrado = tam * tam;
    numBombas = tam - 2;
    for (int i = 0; i < numQuadrado; i++) {
      squareStatus.add([0, false]);
      flagStatus.add([false]);
    }
    resetGame();
    geraNumeros();
  }

  //Mostrar dialogo ao clicar no botao settings
  void _showDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Selecione a quantidade bombas"),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Tabela 5*5
                GestureDetector(
                  onTap: () {
                    setState(() {
                      tamanho(6);
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    child: const Text(
                      "04",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                //Tabela 7*7
                GestureDetector(
                  onTap: () {
                    setState(() {
                      tamanho(9);
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    child: const Text(
                      "08",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                // Tabela 9*9
                GestureDetector(
                  onTap: () {
                    setState(() {
                      tamanho(12);
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    child: const Text(
                      "10",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  //Muda a cor ao clicar
  void revealBox(int index) {
    if (flagStatus[index][0] == false) {
      if (squareStatus[index][0] == 0) {
        setState(() {
          squareStatus[index][1] = true;

          //LeftBox
          if (index % numCol != 0) {
            if (squareStatus[index - 1][0] == 0 &&
                squareStatus[index - 1][1] == false) {
              revealBox(index - 1);
            }
            //Reveal left box
            squareStatus[index - 1][1] = true;
          }

          //Top Left
          if (index % numCol != 0 && index >= numCol) {
            if (squareStatus[index - 1 - numCol][0] == 0 &&
                squareStatus[index - 1 - numCol][1] == false) {
              revealBox(index - 1 - numCol);
            }
            squareStatus[index - 1 - numCol][1] = true;
          }

          //Top Right
          if (index >= numCol) {
            if (squareStatus[index - numCol][0] == 0 &&
                squareStatus[index - numCol][1] == false) {
              revealBox(index - numCol);
            }
            squareStatus[index - numCol][1] = true;
          }

          //Right
          if (index % numCol != numCol - 1) {
            if (squareStatus[index + 1][0] == 0 &&
                squareStatus[index + 1][1] == false) {
              revealBox(index + 1);
            }
            squareStatus[index + 1][1] = true;
          }

          //Bottom right
          if (index < numQuadrado - numCol && index % numCol != numCol - 1) {
            if (squareStatus[index + 1 + numCol][0] == 0 &&
                squareStatus[index + 1 + numCol][1] == false) {
              revealBox(index + 1 + numCol);
            }
            squareStatus[index + 1 + numCol][1] = true;
          }

          //Bottom Left
          if (index < numQuadrado - numCol && index % numCol != 0) {
            if (squareStatus[index - 1 + numCol][0] == 0 &&
                squareStatus[index - 1 + numCol][1] == false) {
              revealBox(index - 1 + numCol);
            }
            squareStatus[index - 1 + numCol][1] = true;
          }

          //Bottom
          if (index < numQuadrado - numCol) {
            if (squareStatus[index + numCol][0] == 0 &&
                squareStatus[index + numCol][1] == false) {
              revealBox(index + numCol);
            }
            squareStatus[index + numCol][1] = true;
          }
        });
      } else {
        setState(() {
          squareStatus[index][1] = true;
        });
      }
    } else {
      setState(() {
        squareStatus[index][1] = false;
      });
    }
  }

  //escaneia as bombas ao redor
  void scanBomb() {
    for (int i = 0; i < numQuadrado; i++) {
      int numeroBombasAoRedor = 0;

      if (!localBombas.contains(i)) {
        //Top left scan
        if (localBombas.contains(i - 1 - numCol) &&
            i % numCol != 0 &&
            i >= numCol) {
          numeroBombasAoRedor++;
        }
        //Top scan
        if (localBombas.contains(i - numCol) && i >= numCol) {
          numeroBombasAoRedor++;
        }
        //Top right
        if (localBombas.contains(i + 1 - numCol) &&
            i >= numCol &&
            i % numCol != numCol - 1) {
          numeroBombasAoRedor++;
        }
        //Left scan - first column
        if (localBombas.contains(i - 1) && i % numCol != 0) {
          numeroBombasAoRedor++;
        }
        //Right
        if (localBombas.contains(i + 1) && i % numCol != numCol - 1) {
          numeroBombasAoRedor++;
        }
        //Bottom Left
        if (localBombas.contains(i - 1 + numCol) &&
            i % numCol != 0 &&
            i < numQuadrado - numCol) {
          numeroBombasAoRedor++;
        }
        //Bottom
        if (localBombas.contains(i + numCol) && i < numQuadrado - numCol) {
          numeroBombasAoRedor++;
        }
        //Bottom Right
        if (localBombas.contains(i + 1 + numCol) &&
            i % numCol != numCol - 1 &&
            i < numQuadrado - numCol) {
          numeroBombasAoRedor++;
        }
      }
      //Adicionar ao squareStatus
      setState(() {
        squareStatus[i][0] = numeroBombasAoRedor;
      });
    }
  }

  //Revela todas as bombas
  bool bombasReveladas = false;

  //Resetar o jogo
  void resetGame() {
    setState(() {
      bombasReveladas = false;
      for (int i = 0; i < numQuadrado; i++) {
        squareStatus[i][1] = false;
        flagStatus[i][0] = false;
      }
      geraNumeros();
    });
  }

  //Perdeu
  void alertaFinal(String alerta) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey[700],
            title: Center(
              child: Text(
                alerta,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            actions: [
              Center(
                child: GestureDetector(
                  onTap: (() {
                    resetGame();
                    Navigator.pop(context);
                  }),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const ShapeDecoration(
                      shape: CircleBorder(),
                      color: Colors.black,
                    ),
                    child: const Icon(
                      Icons.refresh,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  //Checar se ganhou
  void checarGanhador() {
    int unrevealedBoxes = 0;
    for (int i = 0; i < numQuadrado; i++) {
      if (squareStatus[i][1] == false) {
        unrevealedBoxes++;
      }
    }
    if (unrevealedBoxes == localBombas.length) {
      setState(() {
        bombasReveladas = true;
      });
      alertaFinal("Voce Ganhou, Parabens!");
    }
  }

  bool flagActive = false;

  //Mudar o flagActive
  void toggleFlagActive() {
    setState(() {
      flagActive = !flagActive;
    });
  }

  //Mudar o flag status
  void mudaFlag(int i) {
    setState(() {
      if (flagActive == true) {
        flagStatus[i][0] = true;
      } else {
        flagStatus[i][0] = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.grey[200],
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyButtons(
                      onTap: () {
                        resetGame();
                      },
                      teste: const Icon(
                        Icons.refresh_rounded,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      "Campo Minado",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    MyButtons(
                      onTap: _showDialog,
                      teste: const Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: numQuadrado,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: numCol),
                    itemBuilder: (context, index) {
                      if (localBombas.contains(index)) {
                        return CampoTile(
                          flag: flagStatus[index][0],
                          index: "X",
                          bomba: true,
                          revelado: bombasReveladas,
                          onTap: () {
                            mudaFlag(index);

                            setState(
                              () {
                                if (flagStatus[index][0] == false) {
                                  bombasReveladas = true;
                                  alertaFinal("Voce Perdeu!");
                                }
                              },
                            );
                          },
                        );
                      } else {
                        return CampoTile(
                          flag: flagStatus[index][0],
                          index: squareStatus[index][0].toString(),
                          bomba: false,
                          revelado: squareStatus[index][1],
                          onTap: () {
                            mudaFlag(index);

                            revealBox(index);
                            checarGanhador();

                            print(flagStatus[index][0]);
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 100),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: flagActive ? Colors.green : Colors.amber),
                child: GestureDetector(
                  onTap: () {
                    toggleFlagActive();
                  },
                  child: const Icon(
                    Icons.flag,
                    size: 56,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
