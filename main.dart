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









/*
import 'dart:math';

class Player {
  int score = 0;
  int acesHigh = 0;

  void hit() {
    int randomNumber = Random().nextInt(13) + 1;

    if (randomNumber > 10) {
      score += 10;
    } else if (randomNumber == 1) {
      score += 11;
      acesHigh++;
    } else {
      score += randomNumber;
    }

    if (score > 21) {
      if (acesHigh > 0) {
        acesHigh--;
        score -= 10;
      }
    }
  }
  
  bool get busted => score > 21;
}

void main() {
  int turns = 100000;
  int wins = 0, losses = 0;

  for (int i = 0; i < turns; i++) {
    Player player1 = new Player();
    while (player1.score < 17) {
      player1.hit();
    }
    if (player1.busted) {
      losses++;
      continue;
    }

    Player dealer = new Player();
    while (dealer.score < 17) {
      dealer.hit();
    }
    if (dealer.busted) {
      wins++;
      continue;
    }
    
    // print("score: ${player1.score} busted: ${player1.busted}");

    if (player1.score > dealer.score) {
      wins++;
    } else {
      losses++;
    }
  }

  assert(wins + losses == turns);
  double winPercent = (wins / turns) * 100;
  double lossPercent = 100 - winPercent;

  print("WIN Percentage: $winPercent");
  print("LOSS Percentage: $lossPercent");
}
*/