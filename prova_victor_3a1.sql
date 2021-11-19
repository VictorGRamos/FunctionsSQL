-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Tempo de geração: 19-Nov-2021 às 18:11
-- Versão do servidor: 8.0.21
-- versão do PHP: 7.3.21

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `prova_victor_3a1`
--

DELIMITER $$
--
-- Funções
--
/*
Crie uma função que recebe o número de um pedido e retorna um VARCHAR com a
descrição do produto, a quantidade vendida, o preço unitário e data de validade do
produto mais caro do pedido informado como parâmetro.
*/
DROP FUNCTION IF EXISTS `questao_3`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `questao_3` (`n_pedido` INT) RETURNS VARCHAR(200) CHARSET utf8mb4 BEGIN
SET @retorno = "";
SELECT CONCAT(produto.desc_produto," / ", item_pedido.qnt_item_pedido, " Unidades /" , produto.preco_unitario, " Preco Unitario /", produto.dt_validade, " Data Validade")
FROM pedido, item_pedido, produto
WHERE item_pedido.cd_produto = produto.cd_produto AND pedido.nr_pedido = item_pedido.nr_pedido AND
pedido.nr_pedido = 1 ORDER BY preco_unitario DESC limit 1 INTO @retorno;
RETURN @retorno;
END$$

/*
Crie uma função que recebe o código de um produto, um mês e um ano e retorna um
VARCHAR com a descrição do produto, o mês e o ano no formato MM/YYYY e o número
total de itens desse produto que foram vendidos no mês e ano informados como
parâmetro.
*/
DROP FUNCTION IF EXISTS `questao_4`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `questao_4` (`codigo` INT, `mes` INT, `ano` INT) RETURNS VARCHAR(200) CHARSET utf8mb4 BEGIN
SET @retorno = " ";
SELECT CONCAT(produto.desc_produto, " " , item_pedido.nr_item_pedido, " n_item, " , item_pedido.qnt_item_pedido, " Quantidade, " , Month(pedido.dt_pedido), "/" , year(pedido.dt_pedido))
FROM produto, item_pedido, pedido
WHERE item_pedido.cd_produto = produto.cd_produto AND ano = year(dt_pedido) AND mes = month(dt_pedido) AND 
codigo = produto.cd_produto INTO @retorno;
RETURN @retorno;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `item_pedido`
--

DROP TABLE IF EXISTS `item_pedido`;
CREATE TABLE IF NOT EXISTS `item_pedido` (
  `nr_item_pedido` int NOT NULL AUTO_INCREMENT,
  `qnt_item_pedido` int NOT NULL,
  `cd_produto` int NOT NULL,
  `nr_pedido` int NOT NULL,
  PRIMARY KEY (`nr_item_pedido`),
  KEY `cd_produto` (`cd_produto`),
  KEY `nr_pedido` (`nr_pedido`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 COLLATE=latin1_general_cs;

--
-- Extraindo dados da tabela `item_pedido`
--

INSERT INTO `item_pedido` (`nr_item_pedido`, `qnt_item_pedido`, `cd_produto`, `nr_pedido`) VALUES
(1, 4, 5, 1),
(2, 2, 4, 1),
(3, 3, 2, 3),
(4, 1, 3, 4),
(5, 2, 1, 5);

-- --------------------------------------------------------

--
-- Estrutura da tabela `logs_venda`
--

DROP TABLE IF EXISTS `logs_venda`;
CREATE TABLE IF NOT EXISTS `logs_venda` (
  `n_pedido` int NOT NULL,
  `dt_pedido` date DEFAULT NULL,
  `qnt_total_itens` int DEFAULT NULL,
  `valor_total` double(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_cs;

-- --------------------------------------------------------

--
-- Estrutura da tabela `pedido`
--

DROP TABLE IF EXISTS `pedido`;
CREATE TABLE IF NOT EXISTS `pedido` (
  `nr_pedido` int NOT NULL AUTO_INCREMENT,
  `dt_pedido` date DEFAULT NULL,
  `preco_total_pedido` double(10,2) NOT NULL,
  PRIMARY KEY (`nr_pedido`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=latin1 COLLATE=latin1_general_cs;

--
-- Extraindo dados da tabela `pedido`
--

INSERT INTO `pedido` (`nr_pedido`, `dt_pedido`, `preco_total_pedido`) VALUES
(1, '2021-07-20', 130.00),
(2, '2021-11-05', 10.00),
(3, '2021-10-04', 160.00),
(4, '2021-06-09', 30.00),
(5, '2021-09-10', 56.00);

-- --------------------------------------------------------

--
-- Estrutura da tabela `produto`
--

DROP TABLE IF EXISTS `produto`;
CREATE TABLE IF NOT EXISTS `produto` (
  `cd_produto` int NOT NULL AUTO_INCREMENT,
  `desc_produto` varchar(100) COLLATE latin1_general_cs NOT NULL,
  `dt_validade` date DEFAULT NULL,
  `preco_unitario` double(10,2) DEFAULT NULL,
  PRIMARY KEY (`cd_produto`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1 COLLATE=latin1_general_cs;

--
-- Extraindo dados da tabela `produto`
--

INSERT INTO `produto` (`cd_produto`, `desc_produto`, `dt_validade`, `preco_unitario`) VALUES
(1, 'Fone de Ouvido som estereo', '2024-01-31', 24.99),
(2, 'Capinha de Celular ', '2024-01-17', 15.99),
(3, 'Carregador Samsung', '2024-06-13', 30.99),
(4, 'Carregador IPHONE', '2023-06-15', 59.90),
(5, 'Pelicula Vidro', '2022-04-08', 25.00),
(6, 'Teste', '2021-11-02', 12.00);

--
-- Restrições para despejos de tabelas
--

--
-- Limitadores para a tabela `item_pedido`
--
ALTER TABLE `item_pedido`
  ADD CONSTRAINT `item_pedido_ibfk_1` FOREIGN KEY (`cd_produto`) REFERENCES `produto` (`cd_produto`),
  ADD CONSTRAINT `item_pedido_ibfk_2` FOREIGN KEY (`nr_pedido`) REFERENCES `pedido` (`nr_pedido`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
