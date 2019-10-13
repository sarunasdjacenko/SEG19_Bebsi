import 'package:flutter/material.dart';

import 'package:prep/utils/misc_functions.dart';

/// Creates the messages view stateful widget, which shows all of the messages.
class MessagesView extends StatefulWidget {
  final _MessagesViewState _messagesState = _MessagesViewState();

  /// Adds a new message to the messages view state.
  void addMessage({String messageText, DateTime datetime, bool isPatient}) {
    _messagesState._addMessageToList(
      messageText: messageText,
      datetime: datetime,
      isPatient: isPatient,
    );
  }

  @override
  State createState() => _messagesState;
}

/// Creates the state for the messages view.
class _MessagesViewState extends State<MessagesView>
    with TickerProviderStateMixin {
  List<_MessageData> _messagesList = [];

  /// Adds a new message to the list of messages.
  void _addMessageToList(
      {String messageText, DateTime datetime, bool isPatient}) {
    AnimationController animController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    _MessageData _newMessage = _MessageData(
      messageText: messageText,
      datetime: datetime,
      isPatient: isPatient,
      animController: animController,
    );

    setState(() => _messagesList.insert(0, _newMessage));
  }

  /// Disposes the animation controllers clicking off the messaging screen.
  void dispose() {
    for (_MessageData message in _messagesList) {
      message.animController.dispose();
    }
    super.dispose();
  }

  /// Builds the list of all the messages.
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: ListView.builder(
          key: Key('messagesView'),
          padding: EdgeInsets.only(top: 8.0),
          reverse: true,
          itemBuilder: (_, int index) {
            String currentDate = dateFormatter(_messagesList[index].datetime);
            String nextDate = dateFormatter((index == _messagesList.length - 1)
                ? null
                : _messagesList[index + 1].datetime);

            return _MessageListItem(
              message: _messagesList[index],
              showDate: (currentDate == nextDate) ? false : true,
            );
          },
          itemCount: _messagesList.length,
        ),
      ),
    );
  }
}

/// Contains the data of the message.
class _MessageData {
  final String messageText;
  final DateTime datetime;
  final bool isPatient;
  final AnimationController animController;

  _MessageData(
      {@required this.messageText,
      @required this.datetime,
      @required this.isPatient,
      this.animController});
}

/// Stateless widget used to display a particular message on the screen.
class _MessageListItem extends StatelessWidget {
  final _MessageData message;
  final bool showDate;

  _MessageListItem({@required this.message, @required this.showDate})
      : rowAlignment = (message.isPatient)
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        messageBackgroundColor =
            (message.isPatient) ? Colors.blue[200] : Colors.grey[300];

  final MainAxisAlignment rowAlignment;
  final Color messageBackgroundColor;

  /// Widget used to display the time of the message
  Widget _getStatusLine(BuildContext context) {
    return Row(
      mainAxisAlignment: rowAlignment,
      children: <Widget>[
        Text(
          timeFormatter(message.datetime).replaceAll(" ", ""),
          style: TextStyle(fontSize: 12.0),
        ),
      ],
    );
  }

  /// Widget used to display the date of the message
  Widget _getDateLine(BuildContext context) {
    return Column(children: <Widget>[
      Text(
        dateFormatter(message.datetime),
        style: TextStyle(fontSize: 12.0),
      ),
      Divider(),
    ]);
  }

  /// Widget used to display the body of the message
  Widget _getMessageBody(BuildContext context) {
    return Row(
      mainAxisAlignment: rowAlignment,
      children: <Widget>[
        Flexible(
          child: FractionallySizedBox(
            widthFactor: 0.8,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: messageBackgroundColor,
              ),
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  message.messageText,
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds a single message widget.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: <Widget>[
          showDate ? _getDateLine(context) : Container(),
          _getStatusLine(context),
          _getMessageBody(context),
          Divider(),
        ],
      ),
    );
  }
}
