-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 02, 2025 at 08:09 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `bank_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `auth_group`
--

CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_group_permissions`
--

CREATE TABLE `auth_group_permissions` (
  `id` bigint(20) NOT NULL,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_permission`
--

CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `auth_permission`
--

INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
(1, 'Can add log entry', 1, 'add_logentry'),
(2, 'Can change log entry', 1, 'change_logentry'),
(3, 'Can delete log entry', 1, 'delete_logentry'),
(4, 'Can view log entry', 1, 'view_logentry'),
(5, 'Can add permission', 2, 'add_permission'),
(6, 'Can change permission', 2, 'change_permission'),
(7, 'Can delete permission', 2, 'delete_permission'),
(8, 'Can view permission', 2, 'view_permission'),
(9, 'Can add group', 3, 'add_group'),
(10, 'Can change group', 3, 'change_group'),
(11, 'Can delete group', 3, 'delete_group'),
(12, 'Can view group', 3, 'view_group'),
(13, 'Can add content type', 4, 'add_contenttype'),
(14, 'Can change content type', 4, 'change_contenttype'),
(15, 'Can delete content type', 4, 'delete_contenttype'),
(16, 'Can view content type', 4, 'view_contenttype'),
(17, 'Can add session', 5, 'add_session'),
(18, 'Can change session', 5, 'change_session'),
(19, 'Can delete session', 5, 'delete_session'),
(20, 'Can view session', 5, 'view_session'),
(21, 'Can add user', 6, 'add_user'),
(22, 'Can change user', 6, 'change_user'),
(23, 'Can delete user', 6, 'delete_user'),
(24, 'Can view user', 6, 'view_user'),
(25, 'Can add account holder', 7, 'add_accountholder'),
(26, 'Can change account holder', 7, 'change_accountholder'),
(27, 'Can delete account holder', 7, 'delete_accountholder'),
(28, 'Can view account holder', 7, 'view_accountholder'),
(29, 'Can add loan application', 8, 'add_loanapplication'),
(30, 'Can change loan application', 8, 'change_loanapplication'),
(31, 'Can delete loan application', 8, 'delete_loanapplication'),
(32, 'Can view loan application', 8, 'view_loanapplication'),
(33, 'Can add credit card application', 9, 'add_creditcardapplication'),
(34, 'Can change credit card application', 9, 'change_creditcardapplication'),
(35, 'Can delete credit card application', 9, 'delete_creditcardapplication'),
(36, 'Can view credit card application', 9, 'view_creditcardapplication'),
(37, 'Can add loan installment', 10, 'add_loaninstallment'),
(38, 'Can change loan installment', 10, 'change_loaninstallment'),
(39, 'Can delete loan installment', 10, 'delete_loaninstallment'),
(40, 'Can view loan installment', 10, 'view_loaninstallment'),
(41, 'Can add loan disbursement', 11, 'add_loandisbursement'),
(42, 'Can change loan disbursement', 11, 'change_loandisbursement'),
(43, 'Can delete loan disbursement', 11, 'delete_loandisbursement'),
(44, 'Can view loan disbursement', 11, 'view_loandisbursement');

-- --------------------------------------------------------

--
-- Table structure for table `banking_accountholder`
--

CREATE TABLE `banking_accountholder` (
  `id` bigint(20) NOT NULL,
  `account_number` varchar(20) NOT NULL,
  `ifsc` varchar(15) NOT NULL,
  `dob` date NOT NULL,
  `name` varchar(100) NOT NULL,
  `balance` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `banking_accountholder`
--

INSERT INTO `banking_accountholder` (`id`, `account_number`, `ifsc`, `dob`, `name`, `balance`) VALUES
(1, '1234567890', 'IFSC0012345', '1990-01-01', 'Admin User', 100000.00),
(2, '123456789012', 'HDFC0001234', '1990-05-15', 'Rajesh Kumar', 50000.00),
(3, '987654321098', 'SBI0005678', '1985-09-22', 'Priya Sharma', 75000.00),
(4, '456789123456', 'ICIC0004321', '1992-07-30', 'Amit Verma', 62000.50),
(5, '789123456789', 'PNB0007890', '1988-12-10', 'Neha Singh', 89000.75),
(6, '321654987321', 'AXIS0003456', '1995-04-25', 'Ramesh Patel', 45000.25),
(7, '654987321654', 'KOTK0006789', '1991-11-05', 'Sunita Yadav', 56000.10),
(8, '789654123789', 'BOI0002345', '1980-06-14', 'Karan Malhotra', 72000.30),
(9, '147258369147', 'YESB0009123', '1993-03-08', 'Anjali Mehta', 262516.66),
(10, '258369147258', 'IDFC0005678', '1987-08-17', 'Rohit Choudhary', 98000.45),
(11, '369147258369', 'UBI0008765', '1994-02-20', 'Sneha Kapoor', 82000.20);

-- --------------------------------------------------------

--
-- Table structure for table `banking_creditcardapplication`
--

CREATE TABLE `banking_creditcardapplication` (
  `id` bigint(20) NOT NULL,
  `status` varchar(20) NOT NULL,
  `applied_date` datetime(6) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `annual_income` decimal(12,2) NOT NULL,
  `cibil_score` int(11) NOT NULL,
  `employment_status` varchar(100) NOT NULL,
  `id_proof` varchar(100) NOT NULL,
  `salary_slip` varchar(100) DEFAULT NULL,
  `address_proof` varchar(100) NOT NULL,
  `email` varchar(254) NOT NULL,
  `full_name` varchar(200) NOT NULL,
  `phone_number` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `banking_creditcardapplication`
--

INSERT INTO `banking_creditcardapplication` (`id`, `status`, `applied_date`, `user_id`, `annual_income`, `cibil_score`, `employment_status`, `id_proof`, `salary_slip`, `address_proof`, `email`, `full_name`, `phone_number`) VALUES
(1, 'Approved', '2025-02-28 20:04:34.254231', 2, 200000.00, 600, 'Salaried', 'documents/id_proofs/Screenshot_1_OphUftW.png', 'documents/salary_slips/Screenshot_3_Xlm2FSg.png', 'documents/address_proofs/Screenshot_2.png', 'anjali@mail.com', 'Anjali Mehta', '7878787878'),
(2, 'Approved', '2025-03-01 03:12:18.404899', 2, 200000.00, 650, 'Salaried', 'documents/id_proofs/Screenshot_2.png', 'documents/salary_slips/Screenshot_6.png', 'documents/address_proofs/Screenshot_22.png', 'anjali@mail.com', 'Anjali Mehta', '7878787878');

-- --------------------------------------------------------

--
-- Table structure for table `banking_loanapplication`
--

CREATE TABLE `banking_loanapplication` (
  `id` bigint(20) NOT NULL,
  `status` varchar(20) NOT NULL,
  `applied_date` datetime(6) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `id_proof` varchar(100) NOT NULL,
  `loan_amount` decimal(12,2) NOT NULL,
  `possession_certificate` varchar(100) DEFAULT NULL,
  `loan_purpose` longtext NOT NULL,
  `salary_slip` varchar(100) DEFAULT NULL,
  `written_request` varchar(100) NOT NULL,
  `email` varchar(254) NOT NULL,
  `employment_type` varchar(100) NOT NULL,
  `existing_loans` tinyint(1) NOT NULL,
  `full_name` varchar(200) NOT NULL,
  `loan_duration` int(11) NOT NULL,
  `monthly_income` decimal(10,2) NOT NULL,
  `phone_number` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `banking_loanapplication`
--

INSERT INTO `banking_loanapplication` (`id`, `status`, `applied_date`, `user_id`, `id_proof`, `loan_amount`, `possession_certificate`, `loan_purpose`, `salary_slip`, `written_request`, `email`, `employment_type`, `existing_loans`, `full_name`, `loan_duration`, `monthly_income`, `phone_number`) VALUES
(1, 'Pending', '2025-02-28 19:10:02.870398', 2, 'documents/id_proofs/Screenshot_2.png', 200000.00, 'documents/possession_certificates/Screenshot_2.png', 'home', 'documents/salary_slips/Screenshot_1.png', 'documents/written_requests/Screenshot_1.png', 'anjali@mail.com', 'Salaried', 0, 'Anjali Mehta', 56, 50000.00, '7878787878'),
(2, 'Pending', '2025-02-28 19:10:44.936043', 2, 'documents/id_proofs/Screenshot_2_HfkylG7.png', 200000.00, 'documents/possession_certificates/Screenshot_2_OnrjOlm.png', 'home', 'documents/salary_slips/Screenshot_1_qz8wgnt.png', 'documents/written_requests/Screenshot_1_fggohga.png', 'anjali@mail.com', 'Salaried', 0, 'Anjali Mehta', 56, 50000.00, '7878787878'),
(3, 'Approved', '2025-02-28 19:32:04.764938', 2, 'documents/id_proofs/Screenshot_1.png', 200000.00, 'documents/possession_certificates/Screenshot_3.png', 'bike', 'documents/salary_slips/Screenshot_3.png', 'documents/written_requests/Screenshot_2.png', 'anjali@mail.com', 'Salaried', 0, 'Anjali Mehta', 56, 50000.00, '7878787878');

-- --------------------------------------------------------

--
-- Table structure for table `banking_loandisbursement`
--

CREATE TABLE `banking_loandisbursement` (
  `id` bigint(20) NOT NULL,
  `disbursement_date` date NOT NULL,
  `loan_amount` decimal(12,2) NOT NULL,
  `interest_rate` decimal(5,2) NOT NULL,
  `tenure_months` int(11) NOT NULL,
  `monthly_installment` decimal(12,2) NOT NULL,
  `total_repayment_amount` decimal(12,2) NOT NULL,
  `loan_application_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `banking_loandisbursement`
--

INSERT INTO `banking_loandisbursement` (`id`, `disbursement_date`, `loan_amount`, `interest_rate`, `tenure_months`, `monthly_installment`, `total_repayment_amount`, `loan_application_id`) VALUES
(1, '2025-03-01', 200000.00, 10.00, 56, 4483.94, 251100.49, 3);

-- --------------------------------------------------------

--
-- Table structure for table `banking_loaninstallment`
--

CREATE TABLE `banking_loaninstallment` (
  `id` bigint(20) NOT NULL,
  `due_date` date NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `status` varchar(20) NOT NULL,
  `disbursement_id` bigint(20) NOT NULL,
  `order_id` varchar(100) DEFAULT NULL,
  `payment_id` varchar(100) DEFAULT NULL,
  `payment_date` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `banking_loaninstallment`
--

INSERT INTO `banking_loaninstallment` (`id`, `due_date`, `amount`, `status`, `disbursement_id`, `order_id`, `payment_id`, `payment_date`) VALUES
(1, '2025-04-01', 4483.94, 'Paid', 1, 'order_Q1pau41JaY7kyr', 'pay_Q1pfHNOq9ygrJi', '2025-03-02 07:02:43.685642'),
(2, '2025-05-01', 4483.94, 'Pending', 1, 'order_Q1pi5Hnr6BIxZ9', NULL, NULL),
(3, '2025-06-01', 4483.94, 'Pending', 1, 'order_Q1piJbqE3wvhjx', NULL, NULL),
(4, '2025-07-01', 4483.94, 'Pending', 1, 'order_Q1phuS8Qjse5zB', NULL, NULL),
(5, '2025-08-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(6, '2025-09-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(7, '2025-10-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(8, '2025-11-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(9, '2025-12-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(10, '2026-01-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(11, '2026-02-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(12, '2026-03-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(13, '2026-04-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(14, '2026-05-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(15, '2026-06-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(16, '2026-07-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(17, '2026-08-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(18, '2026-09-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(19, '2026-10-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(20, '2026-11-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(21, '2026-12-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(22, '2027-01-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(23, '2027-02-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(24, '2027-03-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(25, '2027-04-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(26, '2027-05-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(27, '2027-06-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(28, '2027-07-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(29, '2027-08-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(30, '2027-09-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(31, '2027-10-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(32, '2027-11-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(33, '2027-12-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(34, '2028-01-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(35, '2028-02-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(36, '2028-03-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(37, '2028-04-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(38, '2028-05-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(39, '2028-06-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(40, '2028-07-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(41, '2028-08-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(42, '2028-09-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(43, '2028-10-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(44, '2028-11-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(45, '2028-12-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(46, '2029-01-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(47, '2029-02-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(48, '2029-03-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(49, '2029-04-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(50, '2029-05-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(51, '2029-06-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(52, '2029-07-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(53, '2029-08-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(54, '2029-09-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(55, '2029-10-01', 4483.94, 'Pending', 1, NULL, NULL, NULL),
(56, '2029-11-01', 4483.94, 'Pending', 1, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `banking_user`
--

CREATE TABLE `banking_user` (
  `id` bigint(20) NOT NULL,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `has_loan` tinyint(1) NOT NULL,
  `account_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `banking_user`
--

INSERT INTO `banking_user` (`id`, `password`, `last_login`, `is_superuser`, `username`, `first_name`, `last_name`, `email`, `is_staff`, `is_active`, `date_joined`, `has_loan`, `account_id`) VALUES
(1, 'pbkdf2_sha256$600000$560t5KCLRn916SlwSC0dvm$8urwQG6odbSsfTKUucX5hpAX1/Oc5hmxGiBYfOPDd6U=', '2025-03-02 07:03:41.615507', 1, 'admin@sbi', 'Admin', 'User', 'admin@sbi.com', 1, 1, '2025-02-28 23:31:16.000000', 0, 1),
(2, 'pbkdf2_sha256$600000$bYzCn6F9kHf3Fnb7pLO83y$NIiiRPuQagX558Xu8h8LtQXs2/qdnkjRBPW3vACnmvk=', '2025-03-02 07:04:23.144467', 0, 'Anjali', '', '', '', 0, 1, '2025-02-28 18:39:04.094999', 0, 9);

-- --------------------------------------------------------

--
-- Table structure for table `banking_user_groups`
--

CREATE TABLE `banking_user_groups` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `group_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `banking_user_user_permissions`
--

CREATE TABLE `banking_user_user_permissions` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `django_admin_log`
--

CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext DEFAULT NULL,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) UNSIGNED NOT NULL CHECK (`action_flag` >= 0),
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `django_content_type`
--

CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `django_content_type`
--

INSERT INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
(1, 'admin', 'logentry'),
(3, 'auth', 'group'),
(2, 'auth', 'permission'),
(7, 'banking', 'accountholder'),
(9, 'banking', 'creditcardapplication'),
(8, 'banking', 'loanapplication'),
(11, 'banking', 'loandisbursement'),
(10, 'banking', 'loaninstallment'),
(6, 'banking', 'user'),
(4, 'contenttypes', 'contenttype'),
(5, 'sessions', 'session');

-- --------------------------------------------------------

--
-- Table structure for table `django_migrations`
--

CREATE TABLE `django_migrations` (
  `id` bigint(20) NOT NULL,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `django_migrations`
--

INSERT INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
(1, 'contenttypes', '0001_initial', '2025-02-28 17:39:06.708502'),
(2, 'contenttypes', '0002_remove_content_type_name', '2025-02-28 17:39:07.284651'),
(3, 'auth', '0001_initial', '2025-02-28 17:39:10.140844'),
(4, 'auth', '0002_alter_permission_name_max_length', '2025-02-28 17:39:11.104721'),
(5, 'auth', '0003_alter_user_email_max_length', '2025-02-28 17:39:11.156770'),
(6, 'auth', '0004_alter_user_username_opts', '2025-02-28 17:39:11.224910'),
(7, 'auth', '0005_alter_user_last_login_null', '2025-02-28 17:39:11.263843'),
(8, 'auth', '0006_require_contenttypes_0002', '2025-02-28 17:39:11.295394'),
(9, 'auth', '0007_alter_validators_add_error_messages', '2025-02-28 17:39:11.342364'),
(10, 'auth', '0008_alter_user_username_max_length', '2025-02-28 17:39:11.374484'),
(11, 'auth', '0009_alter_user_last_name_max_length', '2025-02-28 17:39:11.420932'),
(12, 'auth', '0010_alter_group_name_max_length', '2025-02-28 17:39:11.500383'),
(13, 'auth', '0011_update_proxy_permissions', '2025-02-28 17:39:11.531637'),
(14, 'auth', '0012_alter_user_first_name_max_length', '2025-02-28 17:39:11.578735'),
(15, 'banking', '0001_initial', '2025-02-28 17:39:18.392055'),
(16, 'admin', '0001_initial', '2025-02-28 17:39:19.967752'),
(17, 'admin', '0002_logentry_remove_auto_add', '2025-02-28 17:39:20.049425'),
(18, 'admin', '0003_logentry_add_action_flag_choices', '2025-02-28 17:39:20.112867'),
(19, 'sessions', '0001_initial', '2025-02-28 17:39:20.490913'),
(20, 'banking', '0002_alter_accountholder_balance_alter_accountholder_ifsc_and_more', '2025-02-28 18:35:16.454627'),
(21, 'banking', '0003_rename_amount_loanapplication_annual_income_and_more', '2025-02-28 18:50:13.840059'),
(22, 'banking', '0004_rename_applied_on_creditcardapplication_applied_date_and_more', '2025-02-28 18:54:33.470982'),
(23, 'banking', '0005_loandisbursement_loaninstallment', '2025-03-01 15:58:01.503340'),
(24, 'banking', '0006_loaninstallment_payment_status_and_more', '2025-03-02 06:25:07.434466'),
(25, 'banking', '0007_rename_razorpay_order_id_loaninstallment_order_id_and_more', '2025-03-02 06:25:07.923203');

-- --------------------------------------------------------

--
-- Table structure for table `django_session`
--

CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `django_session`
--

INSERT INTO `django_session` (`session_key`, `session_data`, `expire_date`) VALUES
('0cro6xk0awdcnwrzpzfgclyhj7zuj1xo', '.eJxVjMsOwiAQRf-FtSEUGR4u3fcbyAyDUjWQlHZl_HfbpAvdnnPufYuI61Li2vMcJxYXMYjTLyNMz1x3wQ-s9yZTq8s8kdwTedgux8b5dT3av4OCvWxrgoAB0DingkZNVntlPAfKZwWGbn4wFlL2GomAPDMQm6ATbcAFZcXnC9LNN9M:1toDHo:ddtgenMVeEgcKO7An5ExAHjUfNgWDrLH7_mVbEEK5iE', '2025-03-15 03:13:08.900045'),
('a5wfyz4ytupjoqko85tmwpmmm4oa9e8g', '.eJxVjMsOwiAQRf-FtSEUGR4u3fcbyAyDUjWQlHZl_HfbpAvdnnPufYuI61Li2vMcJxYXMYjTLyNMz1x3wQ-s9yZTq8s8kdwTedgux8b5dT3av4OCvWxrgoAB0DingkZNVntlPAfKZwWGbn4wFlL2GomAPDMQm6ATbcAFZcXnC9LNN9M:1toPOA:Fcx5xD_c1UFj7BfDRlEMDbqcYwdEkWPBlWIpI7PciNg', '2025-03-15 16:08:30.868315'),
('kgf50xt690a0yi6hg12rn1z1v0lk3lm1', '.eJxVjDsOwjAQBe_iGln-O6akzxms9XqNA8iR4qRC3J1ESgHtm5n3ZhG2tcat0xKnzK5MscvvlgCf1A6QH9DuM8e5rcuU-KHwk3Y-zplet9P9O6jQ615bUzz6QsIEnZ1QQSmiTEFYqRHQJhiKMgGlyU478MGnQYNHlMrvBrLPF-G3N9U:1todN9:OgNmqa1NYPOi1Fy82gXCxn_W1trf19isN_9eJtlJzcM', '2025-03-16 07:04:23.191884'),
('tpae0drzk9jq142lqxrsv5hzl51x2uyt', '.eJxVjDsOwjAQBe_iGln-O6akzxms9XqNA8iR4qRC3J1ESgHtm5n3ZhG2tcat0xKnzK5MscvvlgCf1A6QH9DuM8e5rcuU-KHwk3Y-zplet9P9O6jQ615bUzz6QsIEnZ1QQSmiTEFYqRHQJhiKMgGlyU478MGnQYNHlMrvBrLPF-G3N9U:1to7ZQ:TKurbL3vXGhh_Tn-YAcED93gouNcPAzJyeMpAnLyqAQ', '2025-03-14 21:06:56.834370');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `auth_group`
--
ALTER TABLE `auth_group`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  ADD KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`);

--
-- Indexes for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`);

--
-- Indexes for table `banking_accountholder`
--
ALTER TABLE `banking_accountholder`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `account_number` (`account_number`);

--
-- Indexes for table `banking_creditcardapplication`
--
ALTER TABLE `banking_creditcardapplication`
  ADD PRIMARY KEY (`id`),
  ADD KEY `banking_creditcardap_user_id_af79beb9_fk_banking_u` (`user_id`);

--
-- Indexes for table `banking_loanapplication`
--
ALTER TABLE `banking_loanapplication`
  ADD PRIMARY KEY (`id`),
  ADD KEY `banking_loanapplication_user_id_19c23e0d_fk_banking_user_id` (`user_id`);

--
-- Indexes for table `banking_loandisbursement`
--
ALTER TABLE `banking_loandisbursement`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `loan_application_id` (`loan_application_id`);

--
-- Indexes for table `banking_loaninstallment`
--
ALTER TABLE `banking_loaninstallment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `banking_loaninstallm_disbursement_id_1bb0eca3_fk_banking_l` (`disbursement_id`);

--
-- Indexes for table `banking_user`
--
ALTER TABLE `banking_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `account_id` (`account_id`);

--
-- Indexes for table `banking_user_groups`
--
ALTER TABLE `banking_user_groups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `banking_user_groups_user_id_group_id_1f0795d0_uniq` (`user_id`,`group_id`),
  ADD KEY `banking_user_groups_group_id_18d6042f_fk_auth_group_id` (`group_id`);

--
-- Indexes for table `banking_user_user_permissions`
--
ALTER TABLE `banking_user_user_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `banking_user_user_permis_user_id_permission_id_0d0f9144_uniq` (`user_id`,`permission_id`),
  ADD KEY `banking_user_user_pe_permission_id_6051579c_fk_auth_perm` (`permission_id`);

--
-- Indexes for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  ADD KEY `django_admin_log_user_id_c564eba6_fk_banking_user_id` (`user_id`);

--
-- Indexes for table `django_content_type`
--
ALTER TABLE `django_content_type`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`);

--
-- Indexes for table `django_migrations`
--
ALTER TABLE `django_migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `django_session`
--
ALTER TABLE `django_session`
  ADD PRIMARY KEY (`session_key`),
  ADD KEY `django_session_expire_date_a5c62663` (`expire_date`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `auth_group`
--
ALTER TABLE `auth_group`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_permission`
--
ALTER TABLE `auth_permission`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT for table `banking_accountholder`
--
ALTER TABLE `banking_accountholder`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `banking_creditcardapplication`
--
ALTER TABLE `banking_creditcardapplication`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `banking_loanapplication`
--
ALTER TABLE `banking_loanapplication`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `banking_loandisbursement`
--
ALTER TABLE `banking_loandisbursement`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `banking_loaninstallment`
--
ALTER TABLE `banking_loaninstallment`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;

--
-- AUTO_INCREMENT for table `banking_user`
--
ALTER TABLE `banking_user`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `banking_user_groups`
--
ALTER TABLE `banking_user_groups`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `banking_user_user_permissions`
--
ALTER TABLE `banking_user_user_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `django_content_type`
--
ALTER TABLE `django_content_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `django_migrations`
--
ALTER TABLE `django_migrations`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`);

--
-- Constraints for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`);

--
-- Constraints for table `banking_creditcardapplication`
--
ALTER TABLE `banking_creditcardapplication`
  ADD CONSTRAINT `banking_creditcardap_user_id_af79beb9_fk_banking_u` FOREIGN KEY (`user_id`) REFERENCES `banking_user` (`id`);

--
-- Constraints for table `banking_loanapplication`
--
ALTER TABLE `banking_loanapplication`
  ADD CONSTRAINT `banking_loanapplication_user_id_19c23e0d_fk_banking_user_id` FOREIGN KEY (`user_id`) REFERENCES `banking_user` (`id`);

--
-- Constraints for table `banking_loandisbursement`
--
ALTER TABLE `banking_loandisbursement`
  ADD CONSTRAINT `banking_loandisburse_loan_application_id_e6f38630_fk_banking_l` FOREIGN KEY (`loan_application_id`) REFERENCES `banking_loanapplication` (`id`);

--
-- Constraints for table `banking_loaninstallment`
--
ALTER TABLE `banking_loaninstallment`
  ADD CONSTRAINT `banking_loaninstallm_disbursement_id_1bb0eca3_fk_banking_l` FOREIGN KEY (`disbursement_id`) REFERENCES `banking_loandisbursement` (`id`);

--
-- Constraints for table `banking_user`
--
ALTER TABLE `banking_user`
  ADD CONSTRAINT `banking_user_account_id_f3738919_fk_banking_accountholder_id` FOREIGN KEY (`account_id`) REFERENCES `banking_accountholder` (`id`);

--
-- Constraints for table `banking_user_groups`
--
ALTER TABLE `banking_user_groups`
  ADD CONSTRAINT `banking_user_groups_group_id_18d6042f_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  ADD CONSTRAINT `banking_user_groups_user_id_cbf57dad_fk_banking_user_id` FOREIGN KEY (`user_id`) REFERENCES `banking_user` (`id`);

--
-- Constraints for table `banking_user_user_permissions`
--
ALTER TABLE `banking_user_user_permissions`
  ADD CONSTRAINT `banking_user_user_pe_permission_id_6051579c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `banking_user_user_pe_user_id_856a6051_fk_banking_u` FOREIGN KEY (`user_id`) REFERENCES `banking_user` (`id`);

--
-- Constraints for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  ADD CONSTRAINT `django_admin_log_user_id_c564eba6_fk_banking_user_id` FOREIGN KEY (`user_id`) REFERENCES `banking_user` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
