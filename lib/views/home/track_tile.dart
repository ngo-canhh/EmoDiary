import 'package:emodiary/database/entity.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class TrackTile extends StatelessWidget {
  final Track track;
  final Function(Track)? onTap;
  final Track? currentTrack;


  const TrackTile({super.key, required this.track, this.onTap, this.currentTrack});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.network(
          track.thumbnailUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        track.title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        track.artist,
        style: const TextStyle(
          color: Colors.grey,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      trailing: icon(),
      onTap: () {
        if (onTap != null) {
          onTap!(track);
        }
      },
    );
  }

  Widget icon() {
    if (currentTrack == null) {
      return FaIcon(FontAwesomeIcons.headphones);
    } else if (currentTrack!.id == track.id) {
      return FaIcon(FontAwesomeIcons.waveSquare);
    } else {
      return FaIcon(FontAwesomeIcons.headphones);
    }
  }
}

