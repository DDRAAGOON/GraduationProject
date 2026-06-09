import 'package:flutter/foundation.dart';
import '../../data/models/chat/chat_room.dart';
import '../../data/models/chat/chat_models.dart';
import '../../data/services/chat_service.dart';

class ChatStore extends ChangeNotifier {
  ChatStore._();
  static final ChatStore instance = ChatStore._();

  late ChatService _chatService;
  bool _initialized = false;

  void initialize(ChatService chatService) {
    if (!_initialized) {
      _chatService = chatService;
      _initialized = true;
    }
  }

  // State
  List<ChatRoom> _chatRooms = [];
  final Map<String, List<ChatMessage>> _messages = {};
  bool _isLoadingRooms = false;
  final Map<String, bool> _isLoadingMessages = {};

  // Getters
  List<ChatRoom> get chatRooms => _chatRooms;
  bool get isLoadingRooms => _isLoadingRooms;

  List<ChatMessage> getMessages(String roomId) => _messages[roomId] ?? [];
  bool isLoadingMessages(String roomId) => _isLoadingMessages[roomId] ?? false;

  // Actions
  Future<void> loadChatRooms(String userId) async {
    if (!_initialized) return;
    _isLoadingRooms = true;
    notifyListeners();

    try {
      final rawRooms = await _chatService.getMyChats(userId);
      _chatRooms = rawRooms.map((json) {
        if (json is ChatRoom) return json;
        return ChatRoom.fromJson(json as Map<String, dynamic>);
      }).toList();

      // Sort by last message time
      _chatRooms.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
    } catch (e) {
      if (kDebugMode) debugPrint('Error loading chat rooms: $e');
    } finally {
      _isLoadingRooms = false;
      notifyListeners();
    }
  }

  Future<void> loadMessages(
    String userId,
    String otherId, {
    int page = 1,
  }) async {
    if (!_initialized) return;
    final roomId = otherId; // Use otherId as roomId for P2P
    _isLoadingMessages[roomId] = true;
    notifyListeners();

    try {
      final history = await _chatService.getP2PHistory(
        userId,
        otherId,
        page: page,
      );

      if (page == 1) {
        _messages[roomId] = history;
      } else {
        final existing = _messages[roomId] ?? [];
        _messages[roomId] = [...existing, ...history];
      }

      // Mark as read locally
      await _chatService.markAsRead(userId, otherId);
      final roomIndex = _chatRooms.indexWhere((r) => r.recipientId == otherId);
      if (roomIndex != -1) {
        final room = _chatRooms[roomIndex];
        _chatRooms[roomIndex] = ChatRoom(
          id: room.id,
          name: room.name,
          avatarUrl: room.avatarUrl,
          lastMessage: room.lastMessage,
          lastMessageTime: room.lastMessageTime,
          unreadCount: 0,
          recipientId: room.recipientId,
        );
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Error loading messages: $e');
    } finally {
      _isLoadingMessages[roomId] = false;
      notifyListeners();
    }
  }

  void addMessage(String roomId, ChatMessage message) {
    final existing = _messages[roomId] ?? [];
    // Insert at beginning (newest first in UI) or end depending on UI ListView builder.
    // Assuming newest at bottom, so add to end or beginning based on chat_thread_screen structure.
    // Usually chat lists are reversed. We'll add to the beginning so it shows at bottom of a reversed list.
    _messages[roomId] = [message, ...existing];

    // Update room's last message
    final roomIndex = _chatRooms.indexWhere((r) => r.recipientId == roomId);
    if (roomIndex != -1) {
      final room = _chatRooms[roomIndex];
      _chatRooms[roomIndex] = ChatRoom(
        id: room.id,
        name: room.name,
        avatarUrl: room.avatarUrl,
        lastMessage: message.content,
        lastMessageTime: message.createdAt,
        unreadCount: message.isRead ? room.unreadCount : room.unreadCount + 1,
        recipientId: room.recipientId,
      );
      // Re-sort
      _chatRooms.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
    }

    notifyListeners();
  }

  void markRoomAsRead(String roomId) {
    final roomIndex = _chatRooms.indexWhere((r) => r.recipientId == roomId);
    if (roomIndex != -1) {
      final room = _chatRooms[roomIndex];
      _chatRooms[roomIndex] = ChatRoom(
        id: room.id,
        name: room.name,
        avatarUrl: room.avatarUrl,
        lastMessage: room.lastMessage,
        lastMessageTime: room.lastMessageTime,
        unreadCount: 0,
        recipientId: room.recipientId,
      );
      notifyListeners();
    }
  }
}
