-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Nov 14, 2024 at 12:49 PM
-- Server version: 10.4.33-MariaDB-log
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `gympro`
--

-- --------------------------------------------------------

--
-- Table structure for table `appointments`
--

CREATE TABLE `appointments` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `date` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `booking`
--

CREATE TABLE `booking` (
  `id` int(11) NOT NULL,
  `member_name` varchar(100) DEFAULT NULL,
  `equipment` varchar(100) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `user_name` varchar(100) DEFAULT NULL,
  `contact_number` varchar(15) DEFAULT NULL,
  `appointment_date` datetime DEFAULT NULL,
  `appointment_time` time DEFAULT NULL,
  `message` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `booking`
--

INSERT INTO `booking` (`id`, `member_name`, `equipment`, `date`, `status`, `user_name`, `contact_number`, `appointment_date`, `appointment_time`, `message`) VALUES
(2, 'John Doe', 'Laptop', '2024-11-12 00:00:00', 'pending', 'Admin', '63123456', '2024-11-13 00:00:00', '14:30:00', 'Test message 1'),
(3, 'Jane Smith', 'Projector', '2024-11-12 00:00:00', 'confirmed', 'Admin', '63123457', '2024-11-13 00:00:00', '09:00:00', 'Test message 2'),
(4, 'Alice Brown', 'Camera', '2024-11-12 00:00:00', 'pending', 'Test', '63123458', '2024-11-13 00:00:00', '11:00:00', 'Test message 3'),
(5, 'Bob White', 'Microphone', '2024-11-12 00:00:00', 'confirmed', 'Admin', '63123459', '2024-11-14 00:00:00', '08:00:00', 'Test message 4'),
(6, 'Charlie Green', 'Speaker', '2024-11-12 00:00:00', 'pending', 'Admin', '63123460', '2024-11-13 00:00:00', '10:30:00', 'Test message 5'),
(7, 'Diana Blue', 'Printer', '2024-11-12 00:00:00', 'confirmed', 'Test', '63123461', '2024-11-13 00:00:00', '12:00:00', 'Test message 6'),
(8, 'Eva Black', 'Scanner', '2024-11-12 00:00:00', 'pending', 'Test', '63123462', '2024-11-13 00:00:00', '15:00:00', 'Test message 7'),
(9, 'Frank Red', 'Whiteboard', '2024-11-12 00:00:00', 'confirmed', 'Admin', '63123463', '2024-11-13 00:00:00', '17:00:00', 'Test message 8'),
(10, 'Grace Purple', 'Projector', '2024-11-12 00:00:00', 'pending', 'Test', '63123464', '2024-11-13 00:00:00', '16:00:00', 'Test message 9'),
(11, 'Grace Purple', 'Projector', '2024-11-12 00:00:00', 'pending', 'Test', '63123464', '2024-11-13 00:00:00', '16:00:00', 'Test message 9');

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

CREATE TABLE `bookings` (
  `id` int(11) NOT NULL,
  `user_name` varchar(255) NOT NULL,
  `contact_number` varchar(20) NOT NULL,
  `appointment_date` date NOT NULL,
  `appointment_time` time NOT NULL,
  `message` text DEFAULT NULL,
  `status` varchar(20) DEFAULT 'Pending'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `borrowing`
--

CREATE TABLE `borrowing` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `equipment_id` int(11) DEFAULT NULL,
  `borrow_date` timestamp NULL DEFAULT current_timestamp(),
  `return_date` timestamp NULL DEFAULT NULL,
  `status` enum('Borrowed','Returned') DEFAULT 'Borrowed'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `equipment`
--

CREATE TABLE `equipment` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `quantity` int(11) NOT NULL,
  `status` enum('available','unavailable') DEFAULT 'available'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `equipment_borrowing`
--

CREATE TABLE `equipment_borrowing` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `return_date` datetime DEFAULT NULL,
  `equipment_id` int(11) NOT NULL,
  `borrow_date` datetime DEFAULT current_timestamp(),
  `status` varchar(255) NOT NULL DEFAULT 'borrowed'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `feedback`
--

CREATE TABLE `feedback` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `message` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `feedback`
--

INSERT INTO `feedback` (`id`, `user_id`, `message`, `created_at`) VALUES
(8, 16, 'TEST', '2024-11-14 04:48:56');

-- --------------------------------------------------------

--
-- Table structure for table `inventory`
--

CREATE TABLE `inventory` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `quantity` int(11) NOT NULL,
  `status` varchar(50) DEFAULT NULL,
  `added_date` date DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `condition` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `inventory`
--

INSERT INTO `inventory` (`id`, `name`, `quantity`, `status`, `added_date`, `image`, `condition`) VALUES
(2, 'Jumping Rope', 2, NULL, '2024-11-03', 'jumprope.png', 'New'),
(3, 'Yoga Mat', 4, NULL, '2024-11-03', 'yogamat.png', 'New');

-- --------------------------------------------------------

--
-- Table structure for table `member`
--

CREATE TABLE `member` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `contact` varchar(50) DEFAULT NULL,
  `joined_date` datetime DEFAULT NULL,
  `visit_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `members`
--

CREATE TABLE `members` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `visit_date` date DEFAULT NULL,
  `id_number` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `membership_activity`
--

CREATE TABLE `membership_activity` (
  `id` int(11) NOT NULL,
  `new_members` int(11) DEFAULT 0,
  `member_visits` int(11) DEFAULT 0,
  `bookings_this_month` int(11) DEFAULT 0,
  `report_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `seen` tinyint(1) DEFAULT NULL,
  `message` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `user_id`, `seen`, `message`, `created_at`) VALUES
(4, 13, 0, 'Your booking request has been rejected. Reason: sad. Solution: sad.', '2024-11-12 09:58:50'),
(5, 13, 0, 'Your booking request has been rejected. Reason: Test. Solution: test.', '2024-11-12 10:02:24'),
(6, 13, 0, 'Your booking request has been rejected. Reason: Re. Solution: sg.', '2024-11-12 10:03:51'),
(7, 16, 0, 'Your booking request has been rejected. Reason: sad. Solution: sad.', '2024-11-12 10:07:44'),
(8, 16, 0, 'Your booking request has been rejected. Reason: Sad. Solution: sad.', '2024-11-12 10:09:27');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `firstname` varchar(255) NOT NULL,
  `lastname` varchar(255) NOT NULL,
  `id_number` varchar(255) NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `gender` varchar(10) DEFAULT NULL,
  `contact_number` varchar(20) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `role` varchar(50) DEFAULT NULL,
  `membership_status` varchar(50) DEFAULT NULL,
  `next_appointment` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `firstname`, `lastname`, `id_number`, `password`, `date_of_birth`, `gender`, `contact_number`, `created_at`, `role`, `membership_status`, `next_appointment`) VALUES
(13, 'GymPro', 'User', '2020-1234', 'admin', '2001-10-10', 'female', '63', '2024-10-20 11:45:11', 'user', 'active', NULL),
(14, 'Super', 'Admin', 'admin', 'admin', '2001-01-01', 'male', '639533180925', '2024-10-20 12:10:56', 'admin', 'active', NULL),
(15, 'GymPro', 'User II', '2020-1221', 'admin', '1999-01-01', 'Male', '09999999990', '2024-10-21 10:30:11', 'user', 'active', '2024-10-22 10:00:00'),
(16, 'seancvpugosa@gmail.com', 'seancvpugosa@gmail.com', 'seancvpugosa@gmail.com', 'seancvpugosa@gmail.com', '2024-11-08', 'male', '63', '2024-11-08 21:52:54', 'user', 'active', NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `booking`
--
ALTER TABLE `booking`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `equipment_borrowing`
--
ALTER TABLE `equipment_borrowing`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `feedback`
--
ALTER TABLE `feedback`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `inventory`
--
ALTER TABLE `inventory`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `booking`
--
ALTER TABLE `booking`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `bookings`
--
ALTER TABLE `bookings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `equipment_borrowing`
--
ALTER TABLE `equipment_borrowing`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `feedback`
--
ALTER TABLE `feedback`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `inventory`
--
ALTER TABLE `inventory`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
