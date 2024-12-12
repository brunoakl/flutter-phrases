const express = require('express');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

let frasesFavoritas = [];
const frasesAleatorias = [
    "O sucesso é a soma de pequenos esforços repetidos dia após dia.",
    "A persistência é o caminho do êxito.",
    "Não espere por oportunidades, crie-as.",
    "Acredite em si mesmo e em tudo que você é capaz de realizar.",
    "A coragem não é a ausência do medo, mas a capacidade de agir apesar dele.",
    "Você nunca será velho demais para sonhar um novo sonho.",
    "O fracasso é a oportunidade de começar de novo com mais inteligência.",
    "O único lugar onde o sucesso vem antes do trabalho é no dicionário.",
    "Grandes coisas nunca vêm de zonas de conforto.",
    "A vida é 10% o que acontece com você e 90% como você reage a isso.",
    "Seja a mudança que você deseja ver no mundo.",
    "O maior risco é não correr nenhum risco.",
    "Não conte os dias, faça os dias contarem.",
    "A força de vontade é o que move montanhas.",
    "A criatividade é a inteligência se divertindo."
];

//pega uma frase aleatória da lista
app.get('/frase', (req, res) => {
  const frase = frasesAleatorias[Math.floor(Math.random() * frasesAleatorias.length)];
  res.json({ frase });
});

//salva nos favoritos
app.post('/favoritos', (req, res) => {
    const { frase } = req.body;
    if (frase && !frasesFavoritas.includes(frase)) {
        frasesFavoritas.push(frase);
return res.status(201).json({ message: "Frase favoritada com sucesso!" });
  }
  res.status(400).json({ message: "Frase inválida ou já favoritada." });
});

// remover dos favoritos
app.delete('/favoritos', (req, res) => {
    const { frase } = req.body;
    const index = frasesFavoritas.indexOf(frase);
    if (index > -1) {
      frasesFavoritas.splice(index, 1);
      return res.status(200).json({ message: "Frase removida dos favoritos." });
    }
    res.status(400).json({ message: "Frase não encontrada nos favoritos." });
});
  

// lista de frases favoritas
app.get('/favoritos', (req, res) => {
  res.json({ favoritos: frasesFavoritas });
});


//porta da aPI
const PORT = 3000;
app.listen(PORT, () => console.log(`Servidor rodando na porta ${PORT}`));
