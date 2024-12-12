// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:device_calendar/device_calendar.dart';

import 'package:chat_app/bloc/receiveMessage/receive_message_bloc.dart';
import 'package:chat_app/data/local/cache_manager.dart';
import 'package:chat_app/data/models/message_model.dart';
import 'package:chat_app/utils/colors.dart' as cs;

import '../../bloc/sendMessage/send_message_bloc.dart';
import '../../controllers/accept_money_controller.dart';
import '../../data/injection/dependency_injection.dart';
import '../../data/models/users_model.dart';
import '../../services/encrypt_services.dart';
import '../../services/socket_services.dart';

class ChatScreen extends StatefulWidget {
  User? user;
  final ReceiveMessageBloc _receiveMessageBloc;

  ChatScreen({super.key, required this.user})
      : _receiveMessageBloc = ReceiveMessageBloc() {
    _receiveMessageBloc.add(ReceiveMessage(receiverId: user!.id!));
  }

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();
  List<Calendar> _calendars = [];
  Calendar? _selectedCalendar;
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _retrieveCalendars();
  }

  Future<void> _retrieveCalendars() async {
    // Request permissions
    var permissionGranted = await _deviceCalendarPlugin.hasPermissions();
    if (permissionGranted.isSuccess && !permissionGranted.data!) {
      permissionGranted = await _deviceCalendarPlugin.requestPermissions();
      if (!permissionGranted.isSuccess || !permissionGranted.data!) {
        // Handle permission denial
        return;
      }
    }

    // Retrieve calendars
    final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
    print(calendarsResult.data);
    if (calendarsResult.isSuccess) {
      setState(() {
        _calendars = calendarsResult.data!;
        _selectedCalendar = _calendars.isNotEmpty ? _calendars.first : null;
      });
    }
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _scheduleEvent(
      String name, String money, TZDateTime date) async {
    if (_selectedCalendar == null) return;

    final event = Event(
      _selectedCalendar!.id,
      title: 'Money Reminder: $name',
      description: 'You have to pay ₹$money to $name',
      start: TZDateTime.from(DateTime.now().add(Duration(minutes: 5)), local),
      end: TZDateTime.from(DateTime.now().add(Duration(minutes: 10)), local),
      reminders: [Reminder(minutes: 5)], // 5 minutes before the event
    );

    final result = await _deviceCalendarPlugin.createOrUpdateEvent(event);
    if (result!.isSuccess) {
      await _notificationsPlugin.zonedSchedule(
          0,
          'scheduled title',
          'scheduled body',
          TZDateTime.now(local).add(const Duration(seconds: 5)),
          const NotificationDetails(
              android: AndroidNotificationDetails(
                  'your channel id', 'your channel name',
                  channelDescription: 'your channel description')),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime);
      print(result);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event scheduled successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to schedule event.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _messageController = TextEditingController();
    ScrollController _scrollController = new ScrollController();
    AcceptMoneyController _acceptMoneyController =
        Get.put(AcceptMoneyController());
    void scrollToItem(int index) {
      if (!_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeInOut);
      } else {
        _scrollController.animateTo(
          index *
              70, // You may need to adjust this value based on your item height
          duration: Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      }
    }

    return Scaffold(
      backgroundColor: cs.Colors().backGroundColor,
      resizeToAvoidBottomInset: true,
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_sharp,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(45)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(45),
                child: CachedNetworkImage(
                  width: 50,
                  height: 50,
                  imageUrl: widget.user!.profileImageUrl!,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user!.name!,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                Text(widget.user!.phone!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16)),
                StreamBuilder(
                    stream: getIt<SocketServices>().onlineUserStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<dynamic> onlineUsers =
                            snapshot.data as List<dynamic>;
                        print(onlineUsers);
                        return onlineUsers.contains(widget.user!.id)
                            ? const Text("Online",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 15))
                            : const SizedBox.shrink();
                      } else {
                        return const SizedBox.shrink();
                      }
                    })
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocConsumer(
                bloc: widget._receiveMessageBloc,
                listener: (context, state) {
                  // TODO: implement listener
                  if (state is ReceiverMessageSuccess) {
                    Future.delayed(Duration(milliseconds: 50)).then((value) {
                      scrollToItem(
                          widget._receiveMessageBloc.messageData.length - 1);
                    });
                  }
                },
                builder: (context, state) {
                  if (state is ReceiverMessageLoading)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  if (state is ReceiverMessageFailed)
                    return Center(
                      child: Text("Failed Retrive Message"),
                    );
                  if (state is ReceiverMessageSuccess) {
                    return ListView.builder(
                        reverse: false,
                        controller: _scrollController,
                        itemCount: state.messageModel.length,
                        itemBuilder: (context, i) {
                          if (state.messageModel[i].type == 'money') {
                            return Row(
                              mainAxisAlignment:
                                  state.messageModel[i].senderId ==
                                          getIt<CacheManager>().getUserId()
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  decoration: BoxDecoration(
                                      color: state.messageModel[i].senderId ==
                                              getIt<CacheManager>().getUserId()
                                          ? cs.Colors().sendBackgroundColor
                                          : cs.Colors().receiveBackgroundColor,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Sent a Money Reminder of ${DateFormat('dd-MM-yyyy hh:mm a').format((state.messageModel[i].moneyAcceptedAt!.toLocal()))}",
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      BubbleNormal(
                                        text: '₹' +
                                            EncryptServices().decrypt(
                                                state.messageModel[i].message!,
                                                state.messageModel[i].iv!),
                                        isSender: state
                                                .messageModel[i].senderId ==
                                            getIt<CacheManager>().getUserId(),
                                        color: state.messageModel[i].senderId ==
                                                getIt<CacheManager>()
                                                    .getUserId()
                                            ? cs.Colors().sendBackgroundColor
                                            : cs.Colors()
                                                .receiveBackgroundColor,
                                        textStyle: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                      state.messageModel[i].senderId ==
                                              getIt<CacheManager>().getUserId()
                                          ? SizedBox.shrink()
                                          : Row(
                                              children: [
                                                state.messageModel[i].accepted!
                                                    ? SizedBox.shrink()
                                                    : Obx(() =>
                                                        _acceptMoneyController
                                                                .isLoading.value
                                                            ? Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  color: Colors
                                                                      .green,
                                                                ),
                                                              )
                                                            : ElevatedButton(
                                                                onPressed:
                                                                    () async {
                                                                  bool
                                                                      isSucces =
                                                                      await _acceptMoneyController.acceptMoney(state
                                                                          .messageModel[
                                                                              i]
                                                                          .id!);
                                                                  print("Krsh" +
                                                                      isSucces
                                                                          .toString());
                                                                  if (isSucces) {
                                                                    state.messageModel[i] = state
                                                                        .messageModel[
                                                                            i]
                                                                        .copyWith(
                                                                            accepted:
                                                                                true);
                                                                    setState(
                                                                        () {});
                                                                    await _scheduleEvent(
                                                                        widget
                                                                            .user!
                                                                            .name!,
                                                                        EncryptServices().decrypt(
                                                                            state
                                                                                .messageModel[
                                                                                    i]
                                                                                .message!,
                                                                            state
                                                                                .messageModel[
                                                                                    i]
                                                                                .iv!),
                                                                        TZDateTime.from(
                                                                            state.messageModel[i].moneyAcceptedAt!.toLocal(),
                                                                            local));
                                                                  }
                                                                },
                                                                child: Icon(
                                                                  Icons.check,
                                                                  color: Colors
                                                                      .green,
                                                                ))),
                                                state.messageModel[i].accepted!
                                                    ? SizedBox.shrink()
                                                    : SizedBox(
                                                        width: 5,
                                                      ),
                                                Expanded(
                                                    child: Text(
                                                  state.messageModel[i]
                                                          .accepted!
                                                      ? "You Accepted this reminder"
                                                      : "Accept this reminder",
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15),
                                                ))
                                              ],
                                            )
                                    ],
                                  ).paddingAll(5),
                                ).marginSymmetric(horizontal: 5, vertical: 5),
                              ],
                            );
                          }
                          return BubbleSpecialThree(
                            text: EncryptServices().decrypt(
                                state.messageModel[i].message!,
                                state.messageModel[i].iv!),
                            isSender: state.messageModel[i].senderId ==
                                getIt<CacheManager>().getUserId(),
                            color: state.messageModel[i].senderId ==
                                    getIt<CacheManager>().getUserId()
                                ? cs.Colors().sendBackgroundColor
                                : cs.Colors().receiveBackgroundColor,
                            tail: true,
                            textStyle: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ).marginSymmetric(horizontal: 5);
                        }).marginSymmetric(vertical: 3);
                  }
                  return SizedBox.shrink();
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                child: Column(
                  children: [
                    BlocConsumer<SendMessageBloc, SendMessageState>(
                      listener: (context, state) {
                        // TODO: implement listener
                        if (state is SendMessageSuccess) {
                          widget._receiveMessageBloc.add(AddMessage(
                              messageModel: MessageModel.fromJson(
                                  state.sendMessageModel.message!.toJson())));
                          scrollToItem(
                              widget._receiveMessageBloc.messageData.length -
                                  1);
                        }
                      },
                      builder: (context, state) {
                        return MessageBar(
                          actions: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.red, shape: BoxShape.circle),
                              child: IconButton(
                                  onPressed: () {
                                    showMoneyReminderDialog(
                                        context,
                                        widget.user!.id!,
                                        widget._receiveMessageBloc);
                                  },
                                  icon: Icon(Icons.currency_rupee)),
                            ),
                          ],
                          onSend: (_) {
                            if (_.isNotEmpty) {
                              _messageController.clear();
                              context.read<SendMessageBloc>().add(SendMessage(
                                  receiverId: widget.user!.id!,
                                  message: _,
                                  receiveMessageBloc:
                                      widget._receiveMessageBloc,
                                  type: 'text',
                                  dateTime: DateTime.now().toString()));
                            }
                          },
                          onTextChanged: (_) {
                            if (_.isNotEmpty) {
                              print(_);

                              _messageController.text = _;
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  bool isMoneyAmount(String text) {
    print(text);
    final regex = RegExp(r'^\d+(\.\d{1,2})?$');
    return regex.hasMatch(text);
  }
}

class MoneyReminderDialog extends StatefulWidget {
  String userId;
  ReceiveMessageBloc receiveMessageBloc;
  MoneyReminderDialog({
    Key? key,
    required this.userId,
    required this.receiveMessageBloc,
  }) : super(key: key);
  @override
  _MoneyReminderDialogState createState() => _MoneyReminderDialogState();
}

class _MoneyReminderDialogState extends State<MoneyReminderDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Set Money Reminder'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                if (double.tryParse(value) == null) {
                  return 'Enter a valid number';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text(
                _selectedDate == null
                    ? 'Pick a date'
                    : DateFormat('dd MMM yyyy').format(_selectedDate!),
              ),
              trailing: Icon(Icons.calendar_today),
              onTap: _pickDate,
            ),
            ListTile(
              title: Text(
                _selectedTime == null
                    ? 'Pick a time'
                    : _selectedTime!.format(context),
              ),
              trailing: Icon(Icons.access_time),
              onTap: _pickTime,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate() &&
                _selectedDate != null &&
                _selectedTime != null) {
              final amount = double.parse(_amountController.text);
              final reminderDateTime = DateTime(
                _selectedDate!.year,
                _selectedDate!.month,
                _selectedDate!.day,
                _selectedTime!.hour,
                _selectedTime!.minute,
              );
              // Handle submission (e.g., send reminder)
              print('Amount: $amount');
              print('Reminder: $reminderDateTime');
              context.read<SendMessageBloc>().add(SendMessage(
                  receiverId: widget.userId,
                  message: amount.toString(),
                  receiveMessageBloc: widget.receiveMessageBloc,
                  type: 'money',
                  dateTime: reminderDateTime.toString()));
              Navigator.of(context).pop();
            } else {
              if (_selectedDate == null || _selectedTime == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please select date and time')),
                );
              }
            }
          },
          child: Text('Set Reminder'),
        ),
      ],
    );
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }
}

// Example usage
void showMoneyReminderDialog(BuildContext context, String userId,
    ReceiveMessageBloc receiveMessageBloc) {
  showDialog(
    context: context,
    builder: (context) => MoneyReminderDialog(
      receiveMessageBloc: receiveMessageBloc,
      userId: userId,
    ),
  );
}
