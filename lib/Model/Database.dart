import 'dart:developer';
import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

List<dynamic> events;

class CalwinDatabase {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> addUser(Map<String, dynamic> task, String user_id) async {
    await _db
        .collection('users')
        .doc(user_id)
        .set(task, SetOptions(merge: true));
  }

  static Future<void> addEvents(
      Map<String, dynamic> event, String user_id) async {
    await _db.collection('users').doc(user_id).update({
      'events': FieldValue.arrayUnion([
        {
          'title': event['title'],
          'description': event['description'],
          'startTime': event['startTime'],
          'endTime': event['endTime'],
          'attendeeEmail': event['attendeeEmail']
        }
      ])
    });
  }

  static Future<List<dynamic>> getEvents(String user_id) async {
    await _db.collection('users').doc(user_id).get().then((value) {
      {
        //print(value.data()['events']);
        events = value.data()['events'];
        //print(events);
        return events;
      }
    });
  }
  static Map<DateTime,List<dynamic>> getAllEvents(String userID)
  {
    getEvents(userID);
    Map<DateTime,List<dynamic>> allEvents={};
    for (int i = 0; i < events.length; i++) {
      var cc = events[i];
      DateTime eventDate = cc['startTime'].toDate();
      allEvents[eventDate].add(events[i]);
    }
  }
  static List<dynamic> getEventOnSelectedDay(String userID, DateTime curDay) {
    getEvents(userID);
    List<dynamic> curDayEvents = [];
    if (events == null)
      print('fuck');
    else {
      for (int i = 0; i < events.length; i++) {
        var cc = events[i];
        if (cc['startTime'] != null) {
          DateTime eventDate = cc['startTime'].toDate();
          if (eventDate.day == curDay.day &&
              eventDate.month == curDay.month &&
              eventDate.year == curDay.year) curDayEvents.add(events[i]);
        }
      }
      return curDayEvents;
    }
  }
}
