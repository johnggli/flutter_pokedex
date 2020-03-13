import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_pokedex/consts/consts_app.dart';
import 'package:flutter_pokedex/models/pokeapi.dart';
import 'package:flutter_pokedex/stores/pokeapi_store.dart';
import 'package:get_it/get_it.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class PokeDetailPage extends StatefulWidget {
  final int index;
  PokeDetailPage({Key key, this.index}) : super(key: key);

  @override
  _PokeDetailPageState createState() => _PokeDetailPageState();
}

class _PokeDetailPageState extends State<PokeDetailPage> {
  PageController _pageController;
  Pokemon _pokemon;
  PokeApiStore _pokemonStore;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.index);
    _pokemonStore = GetIt.instance<PokeApiStore>();
    _pokemon = _pokemonStore.pokemonAtual;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: Observer(
          builder: (BuildContext context) {
            return AppBar(
              title: Opacity(
                // opacidade em zero por questões de animação.
                child: Text(
                  _pokemon.name,
                  style: TextStyle(
                      fontFamily: 'Google',
                      fontWeight: FontWeight.bold,
                      fontSize: 21),
                ),
                opacity: 0.0,
              ),
              elevation: 0,
              backgroundColor: _pokemonStore.corPokemon,
              leading: IconButton(
                icon: Icon(Icons
                    .arrow_back), // icone de flecha pra voltar à tela anterior.
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.favorite_border), // icone de coração.
                  onPressed: () {},
                ),
              ],
            );
          },
        ),
      ),
      body: Stack(
        children: <Widget>[
          Observer(
            builder: (context) {
              return Container(
                color: _pokemonStore.corPokemon,
              );
            },
          ),
          Container(
            // color: Colors.red,
            height: MediaQuery.of(context).size.height / 3,
          ),
          SlidingSheet(
            elevation: 0, // sombra
            cornerRadius: 30,
            snapSpec: const SnapSpec(
              snap: true,
              snappings: [0.7, 1.0],
              positioning: SnapPositioning.relativeToAvailableSpace,
            ),
            builder: (context, state) {
              return Container(
                height: MediaQuery.of(context).size.height,
              );
            },
          ),
          Padding(
            child: SizedBox(
              height: 200,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  _pokemonStore.setPokemonAtual(index: index);
                },
                itemCount: _pokemonStore.pokeAPI.pokemon.length,
                itemBuilder: (BuildContext context, int index) {
                  Pokemon _pokeItem = _pokemonStore.getPokemon(index: index);
                  return Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Hero(
                        child: Opacity(
                          child: Image.asset(
                            ConstsApp.whitePokeball,
                            height: 270,
                            width: 270,
                          ),
                          opacity: 0.2,
                        ),
                        tag: index.toString(),
                      ),
                      CachedNetworkImage(
                        height: 160,
                        width: 160,
                        placeholder: (context, url) => new Container(
                          color: Colors
                              .transparent, // o que aparece no lugar da imagem quando ela está sendo carregada.
                        ),
                        imageUrl:
                            'https://raw.githubusercontent.com/fanzeyi/pokemon.json/master/images/${_pokeItem.num}.png',
                      ),
                    ],
                  );
                },
              ),
            ),
            padding: EdgeInsets.only(top: 60),
          ),
        ],
      ),
    );
  }
}
