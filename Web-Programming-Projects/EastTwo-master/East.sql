-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               5.7.11-log - MySQL Community Server (GPL)
-- Server OS:                    Win64
-- HeidiSQL Version:             9.3.0.4984
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping database structure for east
DROP DATABASE IF EXISTS `east`;
CREATE DATABASE IF NOT EXISTS `east` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `east`;


-- Dumping structure for table east.assignments
DROP TABLE IF EXISTS `assignments`;
CREATE TABLE IF NOT EXISTS `assignments` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `MaxPoints` int(11) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

-- Dumping data for table east.assignments: ~1 rows (approximately)
/*!40000 ALTER TABLE `assignments` DISABLE KEYS */;
REPLACE INTO `assignments` (`ID`, `Name`, `MaxPoints`) VALUES
	(1, 'First Assignment ', 23);
/*!40000 ALTER TABLE `assignments` ENABLE KEYS */;


-- Dumping structure for table east.assignmentsubmissions
DROP TABLE IF EXISTS `assignmentsubmissions`;
CREATE TABLE IF NOT EXISTS `assignmentsubmissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `AssID` int(11) NOT NULL,
  `SubID` int(11) NOT NULL,
  `StudentID` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- Dumping data for table east.assignmentsubmissions: ~3 rows (approximately)
/*!40000 ALTER TABLE `assignmentsubmissions` DISABLE KEYS */;
REPLACE INTO `assignmentsubmissions` (`id`, `AssID`, `SubID`, `StudentID`) VALUES
	(1, 1, 1, 2),
	(2, 1, 2, 3),
	(3, 1, 3, 3);
/*!40000 ALTER TABLE `assignmentsubmissions` ENABLE KEYS */;


-- Dumping structure for table east.courseassignments
DROP TABLE IF EXISTS `courseassignments`;
CREATE TABLE IF NOT EXISTS `courseassignments` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `CourseID` int(11) NOT NULL,
  `AssignmentID` int(11) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

-- Dumping data for table east.courseassignments: ~1 rows (approximately)
/*!40000 ALTER TABLE `courseassignments` DISABLE KEYS */;
REPLACE INTO `courseassignments` (`ID`, `CourseID`, `AssignmentID`) VALUES
	(1, 1, 1);
/*!40000 ALTER TABLE `courseassignments` ENABLE KEYS */;


-- Dumping structure for table east.courses
DROP TABLE IF EXISTS `courses`;
CREATE TABLE IF NOT EXISTS `courses` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- Dumping data for table east.courses: ~2 rows (approximately)
/*!40000 ALTER TABLE `courses` DISABLE KEYS */;
REPLACE INTO `courses` (`ID`, `Name`) VALUES
	(1, 'Volley Ball Course'),
	(3, 'Another Class');
/*!40000 ALTER TABLE `courses` ENABLE KEYS */;


-- Dumping structure for table east.semesters
DROP TABLE IF EXISTS `semesters`;
CREATE TABLE IF NOT EXISTS `semesters` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- Dumping data for table east.semesters: ~3 rows (approximately)
/*!40000 ALTER TABLE `semesters` DISABLE KEYS */;
REPLACE INTO `semesters` (`ID`, `Name`) VALUES
	(1, 'Spring 2016'),
	(2, '2015 - Fall'),
	(3, 'Summer -2015');
/*!40000 ALTER TABLE `semesters` ENABLE KEYS */;


-- Dumping structure for table east.staffcourses
DROP TABLE IF EXISTS `staffcourses`;
CREATE TABLE IF NOT EXISTS `staffcourses` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `CourseID` int(11) NOT NULL,
  `StaffID` int(11) NOT NULL,
  `SemesterID` int(11) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- Dumping data for table east.staffcourses: ~2 rows (approximately)
/*!40000 ALTER TABLE `staffcourses` DISABLE KEYS */;
REPLACE INTO `staffcourses` (`ID`, `CourseID`, `StaffID`, `SemesterID`) VALUES
	(1, 1, 1, 1),
	(3, 3, 1, 2);
/*!40000 ALTER TABLE `staffcourses` ENABLE KEYS */;


-- Dumping structure for table east.studentcourses
DROP TABLE IF EXISTS `studentcourses`;
CREATE TABLE IF NOT EXISTS `studentcourses` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `StudentID` int(11) NOT NULL,
  `CourseID` int(11) NOT NULL,
  `SemesterID` int(11) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- Dumping data for table east.studentcourses: ~2 rows (approximately)
/*!40000 ALTER TABLE `studentcourses` DISABLE KEYS */;
REPLACE INTO `studentcourses` (`ID`, `StudentID`, `CourseID`, `SemesterID`) VALUES
	(1, 2, 1, 1),
	(3, 3, 1, 1);
/*!40000 ALTER TABLE `studentcourses` ENABLE KEYS */;


-- Dumping structure for table east.submissions
DROP TABLE IF EXISTS `submissions`;
CREATE TABLE IF NOT EXISTS `submissions` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `comments` varchar(250) NOT NULL,
  `feedback` varchar(250) NOT NULL,
  `graded` int(11) DEFAULT NULL,
  `filename` varchar(256) NOT NULL,
  `filedata` mediumtext NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- Dumping data for table east.submissions: ~3 rows (approximately)
/*!40000 ALTER TABLE `submissions` DISABLE KEYS */;
REPLACE INTO `submissions` (`ID`, `comments`, `feedback`, `graded`, `filename`, `filedata`) VALUES
	(1, 'my comment', 'feed back ', 25, 'submissions/1/file.png', ''),
	(2, 'asdf', 'adsf', 2, 'here', ''),
	(3, 'adsf', 'asdf', NULL, '2341', '');
/*!40000 ALTER TABLE `submissions` ENABLE KEYS */;


-- Dumping structure for table east.users
DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Email` varchar(30) NOT NULL,
  `AccountType` int(1) NOT NULL,
  `Password` varchar(20) NOT NULL,
  `FirstName` varchar(20) NOT NULL,
  `LastName` int(20) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

-- Dumping data for table east.users: ~4 rows (approximately)
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
REPLACE INTO `users` (`Id`, `Email`, `AccountType`, `Password`, `FirstName`, `LastName`) VALUES
	(1, 'bob@bob.com', 1, 'password', '', 0),
	(2, 'jim@jim.com', 0, 'password', '', 0),
	(3, 'kill@kill.com', 0, 'pass', '', 0),
	(4, 'pp@pete.com', 0, 'pass', 'Peter', 0);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
