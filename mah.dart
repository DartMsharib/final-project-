import 'dart:io';

String input(String msg) {
  stdout.write(msg);
  return stdin.readLineSync() ?? '';
}

class Student {
  String id;
  String name;
  String phone;

  Student(this.id, this.name, this.phone);
}

class Room {
  String roomNo;
  List<Student> students = [];

  Room(this.roomNo);

  bool isfull() => students.length == 3;
}

class Hostel {
  Map<String, List<Room>> rooms = {};

  Set<String> usedIds = {};
  Set<String> usedNames = {};
  Set<String> usedPhones = {};

  Hostel() {
    rooms['science'] = List.generate(10, (i) => Room('Science-${i + 1}'));
    rooms['Medical'] = List.generate(10, (i) => Room('Medical-${i + 1}'));
    rooms['Commerce'] = List.generate(10, (i) => Room('Commerce-${i + 1}'));
    rooms['Engineering'] = List.generate(
      10,
      (i) => Room('Engineering-${i + 1}'),
    );
    rooms['General'] = List.generate(2, (i) => Room('General-${i + 1}'));
  }

  void addStudent(String dep) {
    String id = input("Enter Student ID: ").trim();
    String name = input("Enter Student Name: ").trim();
    String phone = input("Enter Student Phone: ").trim();

    if (usedIds.contains(id)) {
      print("Student ID already exists.");
      return;
    }

    if (usedNames.contains(name.toLowerCase())) {
      print("Student Name already exists.");
      return;
    }

    if (usedPhones.contains(phone)) {
      print("Student Phone already exists.");
      return;
    }

    if (!rooms.containsKey(dep)) dep = 'General';

    Student student = Student(id, name, phone);

    bool added = false;

    for (Room room in rooms[dep]!) {
      if (!room.isfull()) {
        room.students.add(student);
        usedIds.add(id);
        usedNames.add(name.toLowerCase());
        usedPhones.add(phone);

        print('Added to ${room.roomNo}');
        added = true;
        break; // ← ← student add ہوتے ہی loop بند
      } else {
        print('${room.roomNo} full → trying next room');
      }
    }

    if (!added) {
      print('All rooms in $dep are full. Cannot add student.');
    }
  }

  void showStatus() {
    print('\nHostel Status:');
    rooms.forEach((dept, roomList) {
      print('\n$dept');
      for (var room in roomList) {
        if (room.students.isNotEmpty) {
          print('${room.roomNo}: ${room.students.length}/3 students');
        }
      }
    });
  }
}

void main() {
  Hostel hostel = Hostel();

  while (true) {
    print('\n----------1 Add Student-----------------');
    print('----------2 Show Status-------------------');
    print('----------3 Exit-------------------');

    String choice = input('Choose: ');

    if (choice == '1') {
      String dep = input(
        'Enter Department (science/Medical/Commerce/Engineering): ',
      ).trim();

      hostel.addStudent(dep);
    } else if (choice == '2') {
      hostel.showStatus();
    } else if (choice == '3') {
      break;
    } else {
      print('Invalid choice. Try again.');
    }
  }
}
