-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Dec 03, 2024 at 11:40 AM
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
-- Table structure for table `announcements`
--

CREATE TABLE `announcements` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `mobile_number` varchar(15) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `announcements`
--

INSERT INTO `announcements` (`id`, `title`, `description`, `mobile_number`, `email`, `created_at`, `updated_at`) VALUES
(1, 'New Product Launch', 'We are excited to announce the launch of our new product.', '09171234567', 'info@example.com', '2024-11-26 12:45:38', '2024-11-26 12:45:38'),
(2, 'Holiday Schedule', 'Our office will be closed during the holidays.', NULL, 'support@example.com', '2024-11-26 12:45:38', '2024-11-26 12:45:38'),
(3, 'Urgent Maintenance', 'Scheduled maintenance will occur tomorrow from 2-4 PM.', '09281234567', NULL, '2024-11-26 12:45:38', '2024-11-26 12:45:38');

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
(1, '16', NULL, NULL, 'Pending', NULL, NULL, '2024-12-01 00:00:00', '08:00:00', NULL);

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

--
-- Dumping data for table `equipment_borrowing`
--

INSERT INTO `equipment_borrowing` (`id`, `user_id`, `return_date`, `equipment_id`, `borrow_date`, `status`) VALUES
(1, 16, '2024-11-26 14:21:56', 2, '2024-11-21 04:01:48', 'returned'),
(3, 16, '2024-11-26 14:37:17', 2, '2024-11-26 14:36:05', 'returned'),
(5, 16, '2024-11-28 00:00:00', 2, '2024-11-26 15:42:48', 'approve');

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
(2, 'Jumping Rope', 1, NULL, '2024-11-03', 'jumprope.png', 'New'),
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
(8, 16, 0, 'Your booking request has been rejected. Reason: Sad. Solution: sad.', '2024-11-12 10:09:27'),
(9, 13, 0, 'Your booking request has been approved. Date of Request: 2024-12-04 - Time: 11:59 AM.', '2024-11-21 03:55:21'),
(10, 13, 0, 'Your booking request has been approved. Date of Request: 2024-12-04 - Time: 11:59 AM.', '2024-11-21 03:55:51'),
(11, 16, 0, 'Reminder: The item \'Jumping Rope\' is overdue and must be returned.', '2024-11-21 04:06:08'),
(12, 16, 0, 'Your borrowed item \'Jumping Rope\' has been returned successfully.', '2024-11-22 06:20:27'),
(13, 16, 0, 'Your borrowing request for item \'Jumping Rope\' has been accepted.', '2024-11-22 06:20:29');

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
(16, 'seancvpugosa@gmail.com', 'seancvpugosa@gmail.com', 'seancvpugosa@gmail.com', 'seancvpugosa@gmail.com', '2024-11-08', 'male', '63', '2024-11-08 21:52:54', 'user', 'active', NULL),
(17, 'seancvpugosa1@gmail.com', 'seancvpugosa1@gmail.com', 'seancvpugosa1@gmail.com', 'Example@123', '2024-11-14', 'Male', '63', '2024-11-27 15:21:03', 'user', 'active', NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `announcements`
--
ALTER TABLE `announcements`
  ADD PRIMARY KEY (`id`);

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
-- AUTO_INCREMENT for table `announcements`
--
ALTER TABLE `announcements`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `booking`
--
ALTER TABLE `booking`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `bookings`
--
ALTER TABLE `bookings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `equipment_borrowing`
--
ALTER TABLE `equipment_borrowing`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
