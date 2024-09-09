part of "event_screen.dart";

// ignore: must_be_immutable
class EventCard extends StatelessWidget {
  final Event event;
  final int userId;
  Function? likeDislike;
  Function? handleDeleteEvent;
  EventCard(
      {super.key,
      required this.event,
      required this.userId,
      this.likeDislike,
      this.handleDeleteEvent});

  final iconColor = const Color.fromARGB(255, 6, 110, 58);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                          image: event.creator!.avatar != null &&
                                  !event.creator!.avatar!.contains("avatar.jpg")
                              ? DecorationImage(
                                  image: NetworkImage(event.creator!.avatar!),
                                  fit: BoxFit.cover,
                                )
                              : const DecorationImage(
                                  image:
                                      AssetImage("assets/avaters/default.jpg"),
                                  fit: BoxFit.cover,
                                ),
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.amber),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Text(
                        event.creator?.username ?? "username",
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 17),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 25,
                      width: 0.5,
                      color: Colors.black38,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    kLocation(
                      event.location!,
                      Icons.place,
                      iconColor,
                      context,
                    )
                  ],
                ),
              ),
              event.creator?.id == userId
                  ? PopupMenuButton(
                      child: const Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(
                            Icons.more_vert,
                            color: Color.fromARGB(255, 6, 110, 58),
                          )),
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'edit', child: Text('Edit')),
                        const PopupMenuItem(
                            value: 'delete', child: Text('Delete'))
                      ],
                      onSelected: (val) {
                        if (val == 'edit') {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CreateEventForm(
                                    title: 'Edit event',
                                    event: event,
                                  )));
                        } else {
                          handleDeleteEvent!(event.id);
                        }
                      },
                    )
                  : const SizedBox(
                      width: 0,
                    )
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Text('${event.description}'),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 180,
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(event.thumbnail ??
                    "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Row(
            children: [
              kLikeAndComment(
                  event.likesCount ?? 0,
                  event.selfLiked == true
                      ? Icons.favorite
                      : Icons.favorite_outline,
                  event.selfLiked == true ? Colors.red : iconColor, () {
                likeDislike != null ? likeDislike!(event.id) : null;
              }, true),
              Container(
                height: 25,
                width: 0.5,
                color: Colors.black38,
              ),
              likeDislike != null
                  ? kLikeAndComment(
                      event.comments?.length, Icons.sms_outlined, iconColor,
                      () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CommentScreen(
                            event: event,
                          ),
                        ),
                      );
                    }, false)
                  : const SizedBox(
                      width: 0,
                    ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 0.5,
            color: Colors.black26,
          ),
        ],
      ),
    );
  }
}
