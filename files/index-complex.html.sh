#!/bin/bash
yum update -y
yum install -y httpd.x86_64
systemctl start httpd.service
systemctl enable httpd.service

# Dump the HTML content into index.html
cat <<EOT >> /var/www/html/index.html
<!DOCTYPE html>
<html lang='en'>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <title>Mentor Klub</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            line-height: 1.6;
        }
        header {
            background: #333;
            color: #fff;
            padding: 10px 0;
            text-align: center;
        }
        nav {
            display: flex;
            justify-content: center;
            background: #444;
            padding: 10px 0;
        }
        nav a {
            color: #fff;
            padding: 14px 20px;
            text-decoration: none;
            text-transform: uppercase;
        }
        nav a:hover {
            background: #555;
        }
        .hero {
            background: linear-gradient(0deg, rgba(0, 255, 255, 0.3), rgba(0, 255, 255, 0.3)), url('https://picsum.photos/1920/600') no-repeat center center/cover;
            color: #fff;
            height: 600px;
            text-align: center;
            padding-top: 200px;
        }
        .hero h1 {
            font-size: 50px;
            margin-bottom: 20px;
        }
        .hero p {
            font-size: 24px;
        }
        .section {
            padding: 50px;
            text-align: center;
        }
        .section-dark {
            background: #f4f4f4;
        }
        .services, .about, .contact {
            display: flex;
            justify-content: space-around;
            margin-top: 30px;
        }
        .service, .about-item, .contact-item {
            flex-basis: 30%;
            padding: 20px;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        footer {
            background: #333;
            color: #fff;
            padding: 20px 0;
            text-align: center;
        }
    </style>
</head>
<body>

<header>
    <h1>Welcome to Mentor Klub</h1>
</header>

<nav>
    <a href='#hero'>Home</a>
    <a href='#services'>Services</a>
    <a href='#about'>About</a>
    <a href='#contact'>Contact</a>
</nav>

<section id='hero' class='hero'>
    <h1>Your Training Partner in Hungary</h1>
    <p>Empowering your knowledge with reliable educational solutions</p>
</section>

<section id='services' class='section section-dark'>
    <h2>Our Services</h2>
        <div class='service'>
            <h3>Online Trainings</h3>
            <p>Interactive and comprehensive online courses to enhance your skills from anywhere.</p>
        </div>
        <div class='service'>
            <h3>Training Videos</h3>
            <p>High-quality video tutorials on various topics to help you learn at your own pace.</p>
        </div>
        <div class='service'>
            <h3>Career Consulting</h3>
            <p>Expert guidance to help you navigate your career path and achieve your professional goals.</p>
        </div>
    </div>
</section>

<section id='about' class='section'>
    <h2>About Us</h2>
    <div class='about'>
        <div class='about-item'>
            <h3>Our Mission</h3>
            <p>To provide top-notch education and training to help people acquire valuable skills.</p>
        </div>
        <div class='about-item'>
            <h3>Our Vision</h3>
            <p>To help individuals and organizations expand their knowledge and expertise.</p>
        </div>
        <div class='about-item'>
            <h3>Our Values</h3>
            <p>We are committed to providing great training and fostering a learning environment.</p>
        </div>
    </div>
</section>

<section id='contact' class='section section-dark'>
    <h2>Contact Us</h2>
    <div class='contact'>
        <div class='contact-item'>
            <h3>Email</h3>
            <p>info@mentorklub.hu</p>
        </div>
        <div class='contact-item'>
            <h3>Phone</h3>
            <p>+36 1 234 5678</p>
        </div>
        <div class='contact-item'>
            <h3>Address</h3>
            <p>Budapest, Hungary</p>
        </div>
    </div>
</section>

<footer>
    <p>&copy; 2024 Mentor Klub. All Rights Reserved.</p>
</footer>

</body>
</html>
EOT
