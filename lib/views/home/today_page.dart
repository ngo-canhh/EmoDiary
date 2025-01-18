import 'dart:async';
import 'dart:convert';

import 'package:emodiary/views/home/message_card.dart';
import 'package:emodiary/views/home/track_tile.dart';
import 'package:emodiary/database/entity.dart';
import 'package:emodiary/views/home/music_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TodayPage extends StatefulWidget {
  const TodayPage({super.key});

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  final StreamController<List<Track>> _streamController =
      StreamController<List<Track>>();
  Track? currentTrack;

  @override
  void initState() {
    super.initState();
    _getTrendingTracks();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  Future<void> _getTrendingTracks() async {
    final endpoint = "http://127.0.0.1:5001/trending";
    final url = Uri.parse(endpoint);
    final List<Track> tracks = [];

    try {
      final response = await http.Client().send(http.Request('GET', url));

      if (response.statusCode == 200) {
        response.stream
            .transform(utf8.decoder)
            .transform(LineSplitter())
            .listen(
          (line) {
            if (line.isNotEmpty) {
              final trackData = json.decode(line) as Map<String, dynamic>;
              tracks.add(Track.fromMap(trackData));
              _streamController.add(List.from(tracks)); // Phát dữ liệu mới
            }
          },
          onDone: () {
            _streamController.close();
          },
          onError: (e) {
            _showError("Error reading stream data");
            _streamController.addError(e); // Thông báo lỗi vào stream
          },
        );
      } else {
        _showError("Server error: ${response.statusCode}");
        _streamController.addError("Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("Connection error: $e");
      _showError("Cannot connect to the server. Please try again later.");
      _streamController.addError(e);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            MessageCard(),
            if (currentTrack != null)
              MusicCard(
                track: currentTrack!,
                onTap: () => setState(() {
                  currentTrack = null;
                }),
              ),
            Expanded(
              child: StreamBuilder<List<Track>>(
                stream: _streamController.stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Error: ${snapshot.error}",
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        "No tracks available. Please try again later.",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.active) {
                    final tracks = snapshot.data!;
                    return ListView.builder(
                      itemCount: tracks.length + 1,
                      itemBuilder: (context, index) {
                        if (index == tracks.length) {
                          return Center(child: CircularProgressIndicator());
                        }
                        final track = tracks[index];
                        return TrackTile(
                          track: track,
                          currentTrack: currentTrack,
                          onTap: (track) {
                            setState(() {
                              currentTrack = track;
                            });
                          },
                        );
                      },
                    );
                  } else {
                    final tracks = snapshot.data!;
                    return ListView.builder(
                      itemCount: tracks.length,
                      itemBuilder: (context, index) {
                        final track = tracks[index];
                        return TrackTile(
                          track: track,
                          currentTrack: currentTrack,
                          onTap: (track) {
                            setState(() {
                              currentTrack = track;
                            });
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _getTrendingTracks();
        },
        child: Icon(Icons.replay_rounded),
      ),
    );
  }
}
