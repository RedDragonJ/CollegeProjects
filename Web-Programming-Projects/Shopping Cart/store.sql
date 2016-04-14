-- phpMyAdmin SQL Dump
-- version 4.0.10.15
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Mar 18, 2016 at 01:00 PM
-- Server version: 5.5.46
-- PHP Version: 5.6.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `store`
--

-- --------------------------------------------------------

--
-- Table structure for table `Brand`
--

CREATE TABLE IF NOT EXISTS `Brand` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Title` varchar(25) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Dumping data for table `Brand`
--

INSERT INTO `Brand` (`id`, `Title`) VALUES
(1, 'Lexmark'),
(2, 'IBM '),
(3, 'Hewlett Packard'),
(4, 'Canon');

-- --------------------------------------------------------

--
-- Table structure for table `CartProducts`
--

CREATE TABLE IF NOT EXISTS `CartProducts` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `CartID` int(11) NOT NULL,
  `ProductID` int(11) NOT NULL,
  `Qty` int(11) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=41 ;

--
-- Dumping data for table `CartProducts`
--

INSERT INTO `CartProducts` (`ID`, `CartID`, `ProductID`, `Qty`) VALUES
(37, 2, 1, 5000),
(38, 2, 2, 100000),
(40, 1, 2, 100000);

-- --------------------------------------------------------

--
-- Table structure for table `Make`
--

CREATE TABLE IF NOT EXISTS `Make` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Title` varchar(25) NOT NULL,
  `BrandID` int(11) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=18 ;

--
-- Dumping data for table `Make`
--

INSERT INTO `Make` (`ID`, `Title`, `BrandID`) VALUES
(2, '1000', 1),
(3, '2353', 1),
(4, '3000', 1),
(5, '3200', 1),
(6, '4019', 2),
(7, '4029', 2),
(8, '4029+', 2),
(9, '4039', 2),
(10, 'DeskJet 1600C', 3),
(11, 'DeskJet 1600C', 3),
(12, 'DeskJet 400', 3),
(13, 'DeskJet 400L', 3),
(14, 'Color C LBP 460 PS', 4),
(15, 'Color C LBP 333 PS', 4),
(16, 'LBP 532', 4),
(17, 'CBP 222 PS', 4);

-- --------------------------------------------------------

--
-- Table structure for table `PMCompatability`
--

CREATE TABLE IF NOT EXISTS `PMCompatability` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ProductID` int(11) NOT NULL,
  `MakeID` int(11) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=23 ;

--
-- Dumping data for table `PMCompatability`
--

INSERT INTO `PMCompatability` (`ID`, `ProductID`, `MakeID`) VALUES
(1, 1, 2),
(2, 2, 3),
(4, 3, 4),
(5, 4, 5),
(6, 5, 6),
(7, 6, 7),
(8, 7, 8),
(9, 8, 9),
(10, 9, 10),
(11, 10, 11),
(12, 11, 12),
(13, 12, 13),
(14, 13, 14),
(15, 14, 15),
(16, 15, 16),
(17, 16, 17),
(18, 17, 2),
(19, 18, 3),
(20, 19, 4),
(21, 20, 5),
(22, 1, 5);

-- --------------------------------------------------------

--
-- Table structure for table `Product`
--

CREATE TABLE IF NOT EXISTS `Product` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `SKU` int(11) NOT NULL,
  `Descript` varchar(100) NOT NULL,
  `Price` float NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=21 ;

--
-- Dumping data for table `Product`
--

INSERT INTO `Product` (`ID`, `SKU`, `Descript`, `Price`) VALUES
(1, 13400, 'Black Cartridge', 30.5),
(2, 13400, 'Green Cartridge', 75),
(3, 11235, 'Black Cartridge', 32),
(4, 12366, 'Blue Cartridge', 20),
(5, 66432, 'Red Cartridge', 25),
(6, 34234, 'Orange Cartridge', 35),
(7, 24534, 'Black Cartridge', 45),
(8, 23453, 'Blue Cartridge', 45),
(9, 23445, 'Purple Cartridge', 45),
(10, 67432, 'Green Cartridge', 50),
(11, 12345, 'Green Cartridge', 45),
(12, 34523, 'White Cartridge', 100),
(13, 75867, 'Black Cartridge', 45),
(14, 75867, 'Brown Cartridge', 50),
(15, 75867, 'Pink Cartridge', 88),
(16, 66473, 'Green Cartridge', 44),
(17, 34547, 'Black Cartridge', 55),
(18, 67965, 'Blue Cartridge', 66),
(19, 57684, 'Blue Cartridge', 77),
(20, 123421, 'Black Ink', 125);

-- --------------------------------------------------------

--
-- Table structure for table `SessionCart`
--

CREATE TABLE IF NOT EXISTS `SessionCart` (
  `CID` int(11) NOT NULL AUTO_INCREMENT,
  `SessionID` int(11) NOT NULL,
  `Status` int(11) NOT NULL DEFAULT '0',
  `CompleteDate` date DEFAULT NULL,
  `ShipID` int(11) DEFAULT NULL,
  PRIMARY KEY (`CID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `SessionCart`
--

INSERT INTO `SessionCart` (`CID`, `SessionID`, `Status`, `CompleteDate`, `ShipID`) VALUES
(1, 3, 0, NULL, NULL),
(2, 4, 0, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `Sessions`
--

CREATE TABLE IF NOT EXISTS `Sessions` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `UserID` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Dumping data for table `Sessions`
--

INSERT INTO `Sessions` (`ID`, `UserID`) VALUES
(1, NULL),
(2, NULL),
(3, NULL),
(4, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `User`
--

CREATE TABLE IF NOT EXISTS `User` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `FirstName` varchar(50) NOT NULL,
  `LastName` varchar(50) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `Address` varchar(100) NOT NULL,
  `City` varchar(100) NOT NULL,
  `State` varchar(100) NOT NULL,
  `Zip` varchar(100) NOT NULL,
  `Phone` varchar(100) NOT NULL,
  `Credit Card` varchar(100) NOT NULL,
  `Password` varchar(100) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `User`
--

INSERT INTO `User` (`ID`, `FirstName`, `LastName`, `Email`, `Address`, `City`, `State`, `Zip`, `Phone`, `Credit Card`, `Password`) VALUES
(1, 'Killian', 'Carolan', 'k@k.com', '134 Easy St', 'Irwin', 'PA', '15642', '7245551234', '22244455588877', 'password');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
