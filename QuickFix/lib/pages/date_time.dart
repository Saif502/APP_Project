import 'package:flutter/material.dart';
import 'package:QuickFix/animation/FadeAnimation.dart';
import 'package:QuickFix/pages/conform_booking.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:table_calendar/table_calendar.dart';

class DateAndTime extends StatefulWidget {
  final List<String> selectedRooms;

  const DateAndTime({Key? key, required this.selectedRooms}) : super(key: key);

  @override
  _DateAndTimeState createState() => _DateAndTimeState();
}

class _DateAndTimeState extends State<DateAndTime> {
  int _selectedRepeat = 0;
  String _selectedHour = '13:30';
  List<int> _selectedExtraCleaning = [];
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  final List<String> _hours = <String>[
    '01:00',
    '01:30',
    '02:00',
    '02:30',
    '03:00',
    '03:30',
    '04:00',
    '04:30',
    '05:00',
    '05:30',
    '06:00',
    '06:30',
    '07:00',
    '07:30',
    '08:00',
    '08:30',
    '09:00',
    '09:30',
    '10:00',
    '10:30',
    '11:00',
    '11:30',
    '12:00',
    '12:30',
    '13:00',
    '13:30',
    '14:00',
    '14:30',
    '15:00',
    '15:30',
    '16:00',
    '16:30',
    '17:00',
    '17:30',
    '18:00',
    '18:30',
    '19:00',
    '19:30',
    '20:00',
    '20:30',
    '21:00',
    '21:30',
    '22:00',
    '22:30',
    '23:00',
    '23:30',
  ];

  final List<String> _repeat = [
    'No repeat',
    'Every day',
    'Every week',
    'Every month'
  ];

  final List<dynamic> _extraCleaning = [
    ['Washing', 'https://img.icons8.com/office/2x/washing-machine.png', '10'],
    ['Fridge', 'https://img.icons8.com/cotton/2x/fridge.png', '8'],
    [
      'Oven',
      'https://img.icons8.com/external-becris-lineal-color-becris/2x/external-oven-kitchen-cooking-becris-lineal-color-becris.png',
      '8'
    ],
    [
      'Vehicle',
      'https://img.icons8.com/external-vitaliy-gorbachev-blue-vitaly-gorbachev/2x/external-bycicle-carnival-vitaliy-gorbachev-blue-vitaly-gorbachev.png',
      '20'
    ],
    [
      'Windows',
      'https://img.icons8.com/external-kiranshastry-lineal-color-kiranshastry/2x/external-window-interiors-kiranshastry-lineal-color-kiranshastry-1.png',
      '20'
    ],
  ];

  ItemScrollController _scrollController = ItemScrollController();

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 500), () {
      _scrollController.scrollTo(
        index: 24,
        duration: Duration(seconds: 3),
        curve: Curves.easeInOut,
      );
    });
    super.initState();
  }

  void navigateToConfirmBooking() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmBookingPage(
          selectedDate: _selectedDay,
          selectedTime: _selectedHour,
          repeatOption: _repeat[_selectedRepeat],
          extraCleaning: _selectedExtraCleaning,
          selectedRooms: widget.selectedRooms,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToConfirmBooking,
        child: Icon(Icons.arrow_forward_ios),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: FadeAnimation(
                1,
                Padding(
                  padding: EdgeInsets.only(top: 30.0, right: 20.0, left: 20.0),
                  child: Text(
                    'Select Date \nand Time',
                    style: TextStyle(
                      fontSize: 35,
                      color: Colors.grey.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          ];
        },
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                FadeAnimation(
                  1,
                  TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _selectedDay,
                    calendarFormat: _calendarFormat,
                    onFormatChanged: (format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    },
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                      });
                    },
                  ),
                ),
                SizedBox(height: 10),
                FadeAnimation(
                  1.2,
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border:
                          Border.all(width: 1.5, color: Colors.grey.shade200),
                    ),
                    child: ScrollablePositionedList.builder(
                      itemScrollController: _scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: _hours.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedHour = _hours[index];
                            });
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: _selectedHour == _hours[index]
                                  ? Colors.orange.shade100.withOpacity(0.5)
                                  : Colors.orange.withOpacity(0),
                              border: Border.all(
                                color: _selectedHour == _hours[index]
                                    ? Colors.orange
                                    : Colors.white.withOpacity(0),
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _hours[index],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 40),
                FadeAnimation(
                  1.2,
                  Text(
                    "Repeat",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _repeat.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedRepeat = index;
                          });
                        },
                        child: FadeAnimation(
                          (1.2 + index) / 4,
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: _selectedRepeat == index
                                  ? Colors.blue.shade400
                                  : Colors.grey.shade100,
                            ),
                            margin: EdgeInsets.only(right: 20),
                            child: Center(
                              child: Text(
                                _repeat[index],
                                style: TextStyle(
                                  fontSize: 18,
                                  color: _selectedRepeat == index
                                      ? Colors.white
                                      : Colors.grey.shade800,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 40),
                FadeAnimation(
                  1.4,
                  Text(
                    "Additional Service",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _extraCleaning.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_selectedExtraCleaning.contains(index)) {
                              _selectedExtraCleaning.remove(index);
                            } else {
                              _selectedExtraCleaning.add(index);
                            }
                          });
                        },
                        child: FadeAnimation(
                          (1.4 + index) / 4,
                          Container(
                            width: 110,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: _selectedExtraCleaning.contains(index)
                                  ? Colors.blue.shade400
                                  : Colors.transparent,
                            ),
                            margin: EdgeInsets.only(right: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.network(
                                  _extraCleaning[index][1],
                                  height: 40,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  _extraCleaning[index][0],
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        _selectedExtraCleaning.contains(index)
                                            ? Colors.white
                                            : Colors.grey.shade800,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "+${_extraCleaning[index][2]}\$",
                                  style: TextStyle(color: Colors.black),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
