-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Nov 29, 2019 at 09:54 AM
-- Server version: 5.7.26
-- PHP Version: 7.2.18

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ezgoo`
--

-- --------------------------------------------------------

--
-- Table structure for table `airports`
--

DROP TABLE IF EXISTS `airports`;
CREATE TABLE IF NOT EXISTS `airports` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `city` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `airport_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `airports`
--

INSERT INTO `airports` (`id`, `code`, `city`, `airport_name`, `created_at`, `updated_at`) VALUES
(1, 'ocyWL', 'Collierview', 'Dino Airport', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(2, '9CdCN', 'East Daxstad', 'Leola Airport', '2019-11-29 03:52:38', '2019-11-29 03:52:38');

-- --------------------------------------------------------

--
-- Table structure for table `bank_accounts`
--

DROP TABLE IF EXISTS `bank_accounts`;
CREATE TABLE IF NOT EXISTS `bank_accounts` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `bank` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `account_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `account_number` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `bank_accounts`
--

INSERT INTO `bank_accounts` (`id`, `bank`, `account_name`, `account_number`, `created_at`, `updated_at`) VALUES
(1, 'BCA', 'EzGooBCA', '64373', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(2, 'BRI', 'EzGooBRI', '18420', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(3, 'Mandiri', 'EzGooMandiri', '17287', '2019-11-29 03:52:38', '2019-11-29 03:52:38');

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

DROP TABLE IF EXISTS `bookings`;
CREATE TABLE IF NOT EXISTS `bookings` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` int(10) UNSIGNED NOT NULL,
  `schedule_id` int(11) NOT NULL,
  `booking_code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `vehicle` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `bill` decimal(10,2) NOT NULL,
  `expire` datetime NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `bookings_user_id_foreign` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Triggers `bookings`
--
DROP TRIGGER IF EXISTS `restore_booking`;
DELIMITER $$
CREATE TRIGGER `restore_booking` BEFORE DELETE ON `bookings` FOR EACH ROW BEGIN
          SET @oldP = (SELECT passenger FROM detail_bookings WHERE booking_id = OLD.id);
          SET @oldC = (SELECT class FROM detail_bookings WHERE booking_id = OLD.id);
          IF old.vehicle = 'plane' THEN
            IF @oldC = 'eco_seat' THEN
              UPDATE plane_schedules SET eco_seat = eco_seat + @oldP WHERE id = OLD.schedule_id;
            ELSEIF @oldC = 'bus_seat' THEN
              UPDATE plane_schedules SET bus_seat = bus_seat + @oldP WHERE id = OLD.schedule_id;
            ELSEIF @oldC = 'first_seat' THEN
              UPDATE plane_schedules SET first_seat = first_seat + @oldP WHERE id = OLD.schedule_id;
            END IF;
          ELSEIF old.vehicle = 'train' THEN
            IF @oldC = 'eco_seat' THEN
              UPDATE train_schedules SET eco_seat = eco_seat + @oldP WHERE id = OLD.schedule_id;
            ELSEIF @oldC = 'bus_seat' THEN
              UPDATE train_schedules SET bus_seat = bus_seat + @oldP WHERE id = OLD.schedule_id;
            ELSEIF @oldC = 'exec_seat' THEN
              UPDATE train_schedules SET exec_seat = exec_seat + @oldP WHERE id = OLD.schedule_id;
            END IF;
          END IF;
        END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `detail_bookings`
--

DROP TABLE IF EXISTS `detail_bookings`;
CREATE TABLE IF NOT EXISTS `detail_bookings` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `booking_id` int(10) UNSIGNED NOT NULL,
  `passenger` int(11) NOT NULL,
  `class` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `detail_bookings_booking_id_foreign` (`booking_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `groups`
--

DROP TABLE IF EXISTS `groups`;
CREATE TABLE IF NOT EXISTS `groups` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `group` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `groups`
--

INSERT INTO `groups` (`id`, `group`, `created_at`, `updated_at`) VALUES
(1, 'member', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(2, 'admin', '2019-11-29 03:52:38', '2019-11-29 03:52:38');

-- --------------------------------------------------------

--
-- Table structure for table `group_user`
--

DROP TABLE IF EXISTS `group_user`;
CREATE TABLE IF NOT EXISTS `group_user` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `group_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `group_user_group_id_foreign` (`group_id`),
  KEY `group_user_user_id_foreign` (`user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `group_user`
--

INSERT INTO `group_user` (`id`, `group_id`, `user_id`, `created_at`, `updated_at`) VALUES
(1, 1, 1, '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(2, 2, 2, '2019-11-29 03:52:38', '2019-11-29 03:52:38');

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
CREATE TABLE IF NOT EXISTS `migrations` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `migration` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2014_10_12_100000_create_password_resets_table', 1),
(3, '2014_10_12_100001_create_groups_table', 1),
(4, '2014_10_12_100002_create_group_user_table', 1),
(5, '2018_01_25_154144_create_bookings_table', 1),
(6, '2018_01_25_154250_create_detail_bookings_table', 1),
(7, '2018_01_25_154251_create_transactions_table', 1),
(8, '2018_01_25_154314_create_passengers_table', 1),
(9, '2018_01_25_154441_create_planes_table', 1),
(10, '2018_01_25_154442_create_plane_fares_table', 1),
(11, '2018_01_25_154443_create_airports_table', 1),
(12, '2018_01_25_154453_create_plane_schedules_table', 1),
(13, '2018_02_11_150535_create_trains_table', 1),
(14, '2018_02_11_150536_create_train_stations', 1),
(15, '2018_02_11_150537_create_train_fares', 1),
(16, '2018_02_11_150620_create_train_schedules', 1),
(17, '2018_02_21_084438_create_bank_accounts_table', 1),
(18, '2018_03_10_210210_create_trigger_booking', 1);

-- --------------------------------------------------------

--
-- Table structure for table `passengers`
--

DROP TABLE IF EXISTS `passengers`;
CREATE TABLE IF NOT EXISTS `passengers` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `detail_booking_id` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `passengers_detail_booking_id_foreign` (`detail_booking_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

DROP TABLE IF EXISTS `password_resets`;
CREATE TABLE IF NOT EXISTS `password_resets` (
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  KEY `password_resets_email_index` (`email`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `planes`
--

DROP TABLE IF EXISTS `planes`;
CREATE TABLE IF NOT EXISTS `planes` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `plane_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `eco_seat` int(11) NOT NULL,
  `bus_seat` int(11) NOT NULL,
  `first_seat` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `planes`
--

INSERT INTO `planes` (`id`, `plane_name`, `eco_seat`, `bus_seat`, `first_seat`, `created_at`, `updated_at`) VALUES
(1, 'Plane Dorthy', 2, 1, 12, '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(2, 'Plane Odessa', 7, 13, 7, '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(3, 'Plane Quinn', 2, 16, 4, '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(4, 'Plane Bertha', 11, 14, 3, '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(5, 'Plane Alice', 12, 9, 16, '2019-11-29 03:52:38', '2019-11-29 03:52:38');

-- --------------------------------------------------------

--
-- Table structure for table `plane_fares`
--

DROP TABLE IF EXISTS `plane_fares`;
CREATE TABLE IF NOT EXISTS `plane_fares` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `plane_id` int(10) UNSIGNED NOT NULL,
  `eco_seat` decimal(10,2) NOT NULL,
  `bus_seat` decimal(10,2) NOT NULL,
  `first_seat` decimal(10,2) NOT NULL,
  `unique_code` decimal(10,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `plane_fares_plane_id_foreign` (`plane_id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `plane_fares`
--

INSERT INTO `plane_fares` (`id`, `plane_id`, `eco_seat`, `bus_seat`, `first_seat`, `unique_code`, `created_at`, `updated_at`) VALUES
(1, 1, '10000.00', '10000.00', '10000.00', '871.00', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(2, 2, '15000.00', '15000.00', '15000.00', '921.00', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(3, 3, '15000.00', '15000.00', '15000.00', '952.00', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(4, 4, '10000.00', '10000.00', '10000.00', '85.00', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(5, 5, '5000.00', '5000.00', '5000.00', '138.00', '2019-11-29 03:52:38', '2019-11-29 03:52:38');

-- --------------------------------------------------------

--
-- Table structure for table `plane_schedules`
--

DROP TABLE IF EXISTS `plane_schedules`;
CREATE TABLE IF NOT EXISTS `plane_schedules` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `airport_id` int(10) UNSIGNED NOT NULL,
  `plane_id` int(10) UNSIGNED NOT NULL,
  `from` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `destination` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `from_code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `destination_code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `eco_seat` int(11) NOT NULL,
  `bus_seat` int(11) NOT NULL,
  `first_seat` int(11) NOT NULL,
  `boarding_time` datetime NOT NULL,
  `duration` int(11) NOT NULL,
  `gate` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `plane_schedules_plane_id_foreign` (`plane_id`),
  KEY `plane_schedules_airport_id_foreign` (`airport_id`)
) ENGINE=MyISAM AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `plane_schedules`
--

INSERT INTO `plane_schedules` (`id`, `airport_id`, `plane_id`, `from`, `destination`, `from_code`, `destination_code`, `eco_seat`, `bus_seat`, `first_seat`, `boarding_time`, `duration`, `gate`, `created_at`, `updated_at`) VALUES
(1, 2, 3, 'Leola Airport', 'Dino Airport', '9CdCN', 'ocyWL', 6, 8, 1, '2018-06-03 10:52:38', 92, '79', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(2, 2, 2, 'Leola Airport', 'Dino Airport', '9CdCN', 'ocyWL', 3, 5, 9, '2018-06-13 10:52:38', 94, '38', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(3, 2, 1, 'Leola Airport', 'Dino Airport', '9CdCN', 'ocyWL', 10, 1, 8, '2018-07-04 10:52:38', 32, '10', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(4, 2, 3, 'Leola Airport', 'Dino Airport', '9CdCN', 'ocyWL', 4, 3, 5, '2018-06-19 10:52:38', 74, '2', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(5, 2, 3, 'Leola Airport', 'Dino Airport', '9CdCN', 'ocyWL', 4, 7, 9, '2018-07-16 10:52:38', 47, '80', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(6, 1, 2, 'Dino Airport', 'Leola Airport', 'ocyWL', '9CdCN', 9, 9, 1, '2018-06-07 10:52:38', 56, '92', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(7, 2, 4, 'Leola Airport', 'Dino Airport', '9CdCN', 'ocyWL', 2, 6, 8, '2018-06-16 10:52:38', 14, '66', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(8, 2, 5, 'Leola Airport', 'Dino Airport', '9CdCN', 'ocyWL', 4, 3, 2, '2018-06-22 10:52:38', 51, '73', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(9, 2, 5, 'Leola Airport', 'Dino Airport', '9CdCN', 'ocyWL', 5, 5, 2, '2018-06-14 10:52:38', 83, '73', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(10, 2, 3, 'Leola Airport', 'Dino Airport', '9CdCN', 'ocyWL', 8, 3, 2, '2018-06-25 10:52:38', 98, '32', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(11, 1, 1, 'Dino Airport', 'Leola Airport', 'ocyWL', '9CdCN', 7, 9, 2, '2018-05-21 10:52:38', 26, '42', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(12, 1, 5, 'Dino Airport', 'Leola Airport', 'ocyWL', '9CdCN', 8, 6, 7, '2018-06-07 10:52:38', 74, '90', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(13, 2, 1, 'Leola Airport', 'Dino Airport', '9CdCN', 'ocyWL', 4, 5, 1, '2018-06-13 10:52:38', 22, '32', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(14, 2, 4, 'Leola Airport', 'Dino Airport', '9CdCN', 'ocyWL', 8, 9, 2, '2018-07-12 10:52:38', 83, '71', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(15, 2, 1, 'Leola Airport', 'Dino Airport', '9CdCN', 'ocyWL', 1, 7, 2, '2018-06-24 10:52:38', 85, '35', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(16, 1, 4, 'Dino Airport', 'Leola Airport', 'ocyWL', '9CdCN', 1, 4, 8, '2018-05-23 10:52:38', 56, '68', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(17, 1, 2, 'Dino Airport', 'Leola Airport', 'ocyWL', '9CdCN', 5, 8, 2, '2018-06-11 10:52:38', 73, '64', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(18, 2, 2, 'Leola Airport', 'Dino Airport', '9CdCN', 'ocyWL', 8, 8, 10, '2018-06-22 10:52:38', 74, '37', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(19, 1, 1, 'Dino Airport', 'Leola Airport', 'ocyWL', '9CdCN', 5, 9, 5, '2018-07-18 10:52:38', 28, '72', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(20, 2, 3, 'Leola Airport', 'Dino Airport', '9CdCN', 'ocyWL', 2, 10, 10, '2018-06-10 10:52:38', 7, '94', '2019-11-29 03:52:38', '2019-11-29 03:52:38');

-- --------------------------------------------------------

--
-- Table structure for table `trains`
--

DROP TABLE IF EXISTS `trains`;
CREATE TABLE IF NOT EXISTS `trains` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `train_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `eco_seat` int(11) NOT NULL,
  `bus_seat` int(11) NOT NULL,
  `exec_seat` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `trains`
--

INSERT INTO `trains` (`id`, `train_name`, `eco_seat`, `bus_seat`, `exec_seat`, `created_at`, `updated_at`) VALUES
(1, 'Agro Else', 18, 11, 11, '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(2, 'Agro Enola', 17, 11, 19, '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(3, 'Agro Maude', 14, 7, 8, '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(4, 'Agro Jayson', 20, 7, 4, '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(5, 'Agro Hazle', 20, 20, 14, '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(6, 'Agro Pascale', 10, 19, 16, '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(7, 'Agro Autumn', 16, 17, 2, '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(8, 'Agro Roma', 16, 9, 18, '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(9, 'Agro Maybell', 5, 12, 3, '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(10, 'Agro Luigi', 15, 15, 20, '2019-11-29 03:52:38', '2019-11-29 03:52:38');

-- --------------------------------------------------------

--
-- Table structure for table `train_fares`
--

DROP TABLE IF EXISTS `train_fares`;
CREATE TABLE IF NOT EXISTS `train_fares` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `train_id` int(10) UNSIGNED NOT NULL,
  `eco_seat` decimal(10,2) NOT NULL,
  `bus_seat` decimal(10,2) NOT NULL,
  `exec_seat` decimal(10,2) NOT NULL,
  `unique_code` decimal(10,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `train_fares_train_id_foreign` (`train_id`)
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `train_fares`
--

INSERT INTO `train_fares` (`id`, `train_id`, `eco_seat`, `bus_seat`, `exec_seat`, `unique_code`, `created_at`, `updated_at`) VALUES
(1, 1, '10000.00', '10000.00', '10000.00', '673.00', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(2, 2, '10000.00', '10000.00', '10000.00', '132.00', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(3, 3, '10000.00', '10000.00', '10000.00', '93.00', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(4, 4, '15000.00', '15000.00', '15000.00', '653.00', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(5, 5, '10000.00', '10000.00', '10000.00', '140.00', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(6, 6, '15000.00', '15000.00', '15000.00', '108.00', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(7, 7, '10000.00', '10000.00', '10000.00', '34.00', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(8, 8, '10000.00', '10000.00', '10000.00', '623.00', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(9, 9, '5000.00', '5000.00', '5000.00', '505.00', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(10, 10, '15000.00', '15000.00', '15000.00', '792.00', '2019-11-29 03:52:38', '2019-11-29 03:52:38');

-- --------------------------------------------------------

--
-- Table structure for table `train_schedules`
--

DROP TABLE IF EXISTS `train_schedules`;
CREATE TABLE IF NOT EXISTS `train_schedules` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `station_id` int(10) UNSIGNED NOT NULL,
  `train_id` int(10) UNSIGNED NOT NULL,
  `from` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `destination` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `from_code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `destination_code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `boarding_time` datetime NOT NULL,
  `duration` int(11) NOT NULL,
  `eco_seat` int(11) NOT NULL,
  `bus_seat` int(11) NOT NULL,
  `exec_seat` int(11) NOT NULL,
  `platform` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `train_schedules_train_id_foreign` (`train_id`),
  KEY `train_schedules_station_id_foreign` (`station_id`)
) ENGINE=MyISAM AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `train_schedules`
--

INSERT INTO `train_schedules` (`id`, `station_id`, `train_id`, `from`, `destination`, `from_code`, `destination_code`, `boarding_time`, `duration`, `eco_seat`, `bus_seat`, `exec_seat`, `platform`, `created_at`, `updated_at`) VALUES
(1, 1, 6, 'Schultzborough Station', 'North Emilianoton Station', 'zUnRA', 'u7GJF', '2018-07-05 10:52:38', 1561, 2, 4, 9, '23', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(2, 1, 9, 'Schultzborough Station', 'North Emilianoton Station', 'zUnRA', 'u7GJF', '2018-06-07 10:52:38', 1355, 6, 3, 5, '79', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(3, 1, 8, 'Schultzborough Station', 'North Emilianoton Station', 'zUnRA', 'u7GJF', '2018-06-24 10:52:38', 1038, 9, 3, 1, '15', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(4, 2, 2, 'North Emilianoton Station', 'Schultzborough Station', 'u7GJF', 'zUnRA', '2018-06-01 10:52:38', 1105, 2, 4, 2, '21', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(5, 2, 8, 'North Emilianoton Station', 'Schultzborough Station', 'u7GJF', 'zUnRA', '2018-05-16 10:52:38', 1676, 1, 7, 5, '72', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(6, 2, 7, 'North Emilianoton Station', 'Schultzborough Station', 'u7GJF', 'zUnRA', '2018-06-09 10:52:38', 1622, 3, 10, 10, '79', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(7, 2, 6, 'North Emilianoton Station', 'Schultzborough Station', 'u7GJF', 'zUnRA', '2018-05-14 10:52:38', 1066, 6, 4, 9, '12', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(8, 1, 8, 'Schultzborough Station', 'North Emilianoton Station', 'zUnRA', 'u7GJF', '2018-06-27 10:52:38', 1109, 9, 8, 9, '78', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(9, 1, 9, 'Schultzborough Station', 'North Emilianoton Station', 'zUnRA', 'u7GJF', '2018-06-01 10:52:38', 1370, 1, 6, 7, '11', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(10, 1, 3, 'Schultzborough Station', 'North Emilianoton Station', 'zUnRA', 'u7GJF', '2018-06-18 10:52:38', 1441, 1, 7, 4, '37', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(11, 2, 7, 'North Emilianoton Station', 'Schultzborough Station', 'u7GJF', 'zUnRA', '2018-07-01 10:52:38', 1824, 4, 8, 4, '38', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(12, 2, 4, 'North Emilianoton Station', 'Schultzborough Station', 'u7GJF', 'zUnRA', '2018-06-03 10:52:38', 1000, 8, 8, 10, '39', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(13, 1, 4, 'Schultzborough Station', 'North Emilianoton Station', 'zUnRA', 'u7GJF', '2018-05-28 10:52:38', 1745, 5, 3, 7, '87', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(14, 2, 6, 'North Emilianoton Station', 'Schultzborough Station', 'u7GJF', 'zUnRA', '2018-07-11 10:52:38', 1636, 10, 9, 8, '48', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(15, 1, 9, 'Schultzborough Station', 'North Emilianoton Station', 'zUnRA', 'u7GJF', '2018-06-14 10:52:38', 1618, 1, 3, 2, '42', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(16, 1, 3, 'Schultzborough Station', 'North Emilianoton Station', 'zUnRA', 'u7GJF', '2018-06-22 10:52:38', 1638, 5, 1, 7, '93', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(17, 2, 7, 'North Emilianoton Station', 'Schultzborough Station', 'u7GJF', 'zUnRA', '2018-06-12 10:52:38', 1650, 10, 5, 7, '36', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(18, 2, 2, 'North Emilianoton Station', 'Schultzborough Station', 'u7GJF', 'zUnRA', '2018-06-03 10:52:38', 1621, 8, 6, 5, '21', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(19, 1, 1, 'Schultzborough Station', 'North Emilianoton Station', 'zUnRA', 'u7GJF', '2018-06-24 10:52:38', 1429, 1, 4, 3, '47', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(20, 1, 4, 'Schultzborough Station', 'North Emilianoton Station', 'zUnRA', 'u7GJF', '2018-06-02 10:52:38', 1916, 1, 3, 7, '70', '2019-11-29 03:52:38', '2019-11-29 03:52:38');

-- --------------------------------------------------------

--
-- Table structure for table `train_stations`
--

DROP TABLE IF EXISTS `train_stations`;
CREATE TABLE IF NOT EXISTS `train_stations` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `city` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `station_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `train_stations`
--

INSERT INTO `train_stations` (`id`, `code`, `city`, `station_name`, `created_at`, `updated_at`) VALUES
(1, 'zUnRA', 'South Josianneport', 'Schultzborough Station', '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(2, 'u7GJF', 'Lesterside', 'North Emilianoton Station', '2019-11-29 03:52:38', '2019-11-29 03:52:38');

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

DROP TABLE IF EXISTS `transactions`;
CREATE TABLE IF NOT EXISTS `transactions` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `booking_id` int(10) UNSIGNED NOT NULL,
  `bank` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sender_name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ammount` decimal(10,2) DEFAULT NULL,
  `receipt` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `transactions_booking_id_foreign` (`booking_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `first_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` enum('Tuan','Nyonya','Nona') COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `verified` tinyint(1) NOT NULL DEFAULT '0',
  `verification_token` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `first_name`, `last_name`, `title`, `phone`, `email`, `password`, `verified`, `verification_token`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Member EzGoo', 'Member', 'EzGoo', 'Tuan', '082220279970', 'member@ezgoo.com', '$2y$10$MnAR9nKryfJpDEiJ85RJdebqaXO8ik1pnQHGmZbHXG8brjm4cxFNq', 1, '123tokenm', NULL, '2019-11-29 03:52:38', '2019-11-29 03:52:38'),
(2, 'Admin EzGoo', 'Admin', 'EzGoo', 'Tuan', '082220279970', 'admin@ezgoo.com', '$2y$10$LDg.ZEP1IzflXuB5swzCpuiDcUNP61RLdeD9.i959xzejjIhoThL6', 1, '123tokena', 'snIkY2A200Z40yzJ5c5cqgoBuVt77Uinra3cDzzpvGbKTFZ4PMrALmX0InJd', '2019-11-29 03:52:38', '2019-11-29 03:52:38');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
