const express = require("express");
const wrap = require("express-async-error-wrapper");
const axios = require("axios");
const sql = require("../data/sql");

const router = express.Router();

const url_api = process.env.url_api;

router.get("/", wrap(async (req, res) => {

	

	await sql.connect(async sql => {
		const lista = await sql.query("select max(id) id from leituras_sensor");

		let id_inferior = 92107;
		if(lista[0].id) {
			id_inferior = lista[0].id;
		}

		const response = await axios.get(url_api + "?sensor=passage&id_inferior=" + id_inferior);
		const dados = response.data;

		for (let i = 0; i < dados.length; i++) {
			const dadoNovo = dados[i];
			await sql.query("insert into leituras_sensor (id, id_local, pessoas_entrando, pessoas_saindo, data_leitura) values (?, ?, ?, ?, ?)", [dadoNovo.id, dadoNovo.id_sensor, dadoNovo.entrada, dadoNovo.saida, dadoNovo.data]);
		}
	});

	let nomeDoUsuarioQueVeioDoBanco = "Rafael";

	let opcoes = {
		usuario: nomeDoUsuarioQueVeioDoBanco,
		quantidadeDeRepeticoes: 5
	};

	res.render("index/index", opcoes);
}));

router.get("/dadosConsolidadosPorDiaHora", wrap(async (req, res) => {
	await sql.connect(async sql => {
		const dados = await sql.query(`
			select date_format(date(data_leitura), '%d/%m/%Y') dia, extract(hour from data_leitura) hora, sum(pessoas_entrando) total_entrada, sum(pessoas_saindo) total_saida
			from leituras_sensor
			where data_leitura between ? and ?
			and id_local = 2
			group by dia, hora
			order by dia, hora;
		`, [req.query["data_inicial"] + " 00:00:00", req.query["data_final"] + " 23:59:59"]);

		res.json(dados);
	});
}));

router.get("/about", wrap(async (req, res) => {
	res.render("index/about");
}));

router.get("/dash", wrap(async (req, res) => {
	res.render("index/dash");
}));

router.get("/teste", wrap(async (req, res) => {
	let opcoes = {
		layout: "casca-teste"
	};

	res.render("index/teste", opcoes);
}));

router.get("/teste2", wrap(async (req, res) => {
	let opcoes = {
		layout: "casca-teste"
	};

	res.render("index/teste2", opcoes);
}));

router.get("/teste3", wrap(async (req, res) => {
	let opcoes = {
		layout: "casca-teste"
	};

	res.render("index/teste3", opcoes);
}));

router.get("/produtos", wrap(async (req, res) => {
	let produtoA = {
		id: 1,
		nome: "Produto A",
		valor: 25
	};

	let produtoB = {
		id: 2,
		nome: "Produto B",
		valor: 15
	};

	let produtoC = {
		id: 3,
		nome: "Produto C",
		valor: 100
	};

	let produtosVindosDoBanco = [ produtoA, produtoB, produtoC ];

	let opcoes = {
		titulo: "Listagem de Produtos",
		produtos: produtosVindosDoBanco
	};

	res.render("index/produtos", opcoes);
}));

module.exports = router;
