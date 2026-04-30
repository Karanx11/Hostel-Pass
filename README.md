# 🏫 Hostel Pass Management System (Flutter + Supabase)

A **role-based Hostel Pass System** built using **Flutter** and **Supabase**, allowing students to request passes, wardens to approve/reject them, and guards to verify passes via QR scanning.

## 🌐 Live Demo  
👉 https://hostel-pass-app.onrender.com

---

## 🚀 Features

### 👨‍🎓 Student

* Apply for hostel pass
* View pass status (Pending / Approved / Rejected)
* Digital pass with QR code
* Pass history (swipe to delete)
* Profile view

### 👨‍💼 Warden

* View all pass requests
* Approve / Reject passes
* View student details (name, room, hostel)
* Request history
* Profile section

### 🛡️ Guard

* Scan QR code
* Real-time pass verification
* Valid / Expired / Not Approved status
* Profile section

---

## 🧠 Tech Stack

* **Frontend:** Flutter
* **Backend:** Supabase (Auth + Database)
* **Database:** PostgreSQL
* **State Handling:** Stateful Widgets
* **Storage:** SharedPreferences (for role persistence)
* **QR Scanner:** mobile_scanner
* **QR Generator:** qr_flutter

---

## 📂 Project Structure

```
lib/
│
├── screens/
│   ├── auth/
│   ├── student/
│   ├── warden/
│   ├── guard/
│   └── pass/
│
├── services/
│   ├── auth_service.dart
│   ├── user_service.dart
│   └── pass_service.dart
│
├── theme/
│
└── main.dart
```

---

## ⚙️ Setup Instructions

### 1️⃣ Clone Repo

```bash
git clone https://github.com/Karanx11/Hostel-Pass.git
cd hostel-pass
```

---

### 2️⃣ Install Dependencies

```bash
flutter pub get
```

---

### 3️⃣ Setup `.env`

Create a `.env` file in root:

```
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_anon_key
```

---

### 4️⃣ Run App

```bash
flutter run
```

---

## 🗄️ Database Setup (Supabase)

### 🔹 users table

| column      | type |
| ----------- | ---- |
| id          | uuid |
| name        | text |
| email       | text |
| role        | text |
| room_number | text |
| hostel_name | text |

---

### 🔹 passes table

```sql
create table passes (
  id uuid primary key default gen_random_uuid(),
  student_email text,
  destination text,
  reason text,
  out_time timestamp,
  return_time timestamp,
  status text default 'pending',
  created_at timestamp default now()
);
```

---

### 🔹 Foreign Key (IMPORTANT)

```sql
alter table passes
add constraint fk_user_email
foreign key (student_email)
references users(email);
```

---

## 🔐 Authentication Flow

* Supabase Email + Password login
* Role fetched from `users` table
* Role stored locally using SharedPreferences
* Splash screen routes user based on role

---

## 🔄 App Flow

```
Login → Splash → Role Detection → Dashboard
```

---

## 🔳 QR Verification Flow

1. Student gets approved pass
2. QR generated using pass ID
3. Guard scans QR
4. App fetches pass from DB
5. Validates:

   * Status = approved
   * Not expired
6. Shows result

---

## 🧪 Test Credentials

```
Student:
email: student1@gmail.com
pass: student1@123

Warden:
email: warden@gmail.com
pass: warden@123

Guard:
email: guard@gmail.com
pass: guard@123
```

---

## 🛑 Security Notes

* No hardcoded credentials
* Role-based access
* Supabase Auth used
* QR contains only pass ID (secure)

---

## ✨ Future Improvements

* Profile image upload
* Push notifications (approval alerts)
* Real-time updates
* Admin dashboard
* Dark/Light theme toggle
* Offline support

---

## 👨‍💻 Author

Karan Sharma

---

## ⭐ If you like this project

Give it a star ⭐ and share!

---
