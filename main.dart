import 'dart:io';
import 'dart:math';

class Card {
  String suit;
  String rank;
  int value;

  Card(this.suit, this.rank, this.value);

  @override
  String toString() {
    return '$rank de $suit';
  }
}

List<Card> createDeck() {
  List<String> suits = ['Copas', 'Ouros', 'Espadas', 'Paus'];
  List<String> ranks = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'Valete', 'Rainha', 'Rei', 'Ás'];
  List<Card> deck = [];

  for (var suit in suits) {
    for (var rank in ranks) {
      int value;
      if (rank == 'Valete' || rank == 'Rainha' || rank == 'Rei') {
        value = 10;
      } else if (rank == 'Ás') {
        value = 11;
      } else {
        value = int.parse(rank);
      }
      deck.add(Card(suit, rank, value));
    }
  }
  return deck;
}

void shuffleDeck(List<Card> deck) {
  deck.shuffle(Random());
}

List<Card> dealInitialCards(List<Card> deck) {
  return [deck.removeLast(), deck.removeLast()];
}

int calculateHandValue(List<Card> hand) {
  int sum = hand.fold(0, (total, card) => total + card.value);

  for (var card in hand) {
    if (sum > 21 && card.rank == 'Ás') {
      sum -= 10;
    }
  }
  return sum;
}

void playerTurn(List<Card> deck, List<Card> playerHand) {
  while (true) {
    print('Sua mão: $playerHand');
    print('Valor da mão: ${calculateHandValue(playerHand)}');
    print('Deseja "hit" (pedir) ou "stand" (parar)?');
    String choice = stdin.readLineSync()!.toLowerCase();

    if (choice == 'hit') {
      playerHand.add(deck.removeLast());
      if (calculateHandValue(playerHand) > 21) {
        print('Você ultrapassou 21! Perdeu.');
        break;
      }
    } else if (choice == 'stand') {
      break;
    }
  }
}

void dealerTurn(List<Card> deck, List<Card> dealerHand) {
  while (calculateHandValue(dealerHand) < 17) {
    dealerHand.add(deck.removeLast());
  }
  print('Mão do dealer: $dealerHand');
  print('Valor da mão do dealer: ${calculateHandValue(dealerHand)}');
}

void determineWinner(List<Card> playerHand, List<Card> dealerHand) {
  int playerTotal = calculateHandValue(playerHand);
  int dealerTotal = calculateHandValue(dealerHand);

  if (playerTotal > 21) {
    print('Você perdeu!');
  } else if (dealerTotal > 21 || playerTotal > dealerTotal) {
    print('Você venceu!');
  } else if (playerTotal < dealerTotal) {
    print('O dealer venceu!');
  } else {
    print('Empate!');
  }
}

void main() {
  List<Card> deck = createDeck();
  shuffleDeck(deck);

  List<Card> playerHand = dealInitialCards(deck);
  List<Card> dealerHand = dealInitialCards(deck);

  playerTurn(deck, playerHand);
  dealerTurn(deck, dealerHand);

  determineWinner(playerHand, dealerHand);
}
