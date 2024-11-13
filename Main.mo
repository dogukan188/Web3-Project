import Principal "mo:base/Principal";
import Array "mo:base/Array";
import Nat "mo:base/Nat";

// Basit Merkeziyetsiz Oylama Dapp'i - Motoko ile
actor VotingApp {

  // Toplam oy sayısını tutan değişkenler
  var yesVotes : Nat = 0;
  var noVotes : Nat = 0;

  // Her kullanıcının sadece bir kez oy verebilmesi için kullanıcı kimliklerini bir Array içinde saklıyoruz
  var votedUsers : [Principal] = [];

  // `voteYes` fonksiyonu "Evet" oyu vermek için kullanılır.
  public func voteYes(user: Principal) : async Text {
    // Kullanıcının daha önce oy verip vermediğini kontrol ediyoruz
    switch (Array.find(votedUsers, func(p : Principal) : Bool { p == user })) {
      case (?user) { return "Zaten oy verdiniz!"; };
      case null { 
        yesVotes += 1;
        votedUsers := Array.append(votedUsers, [user]); // Kullanıcıyı oylayanlar listesine ekliyoruz
        return "Evet oyu verildi!";
      };
    }
  };

  // `voteNo` fonksiyonu "Hayır" oyu vermek için kullanılır
  public func voteNo(user: Principal) : async Text {
    switch (Array.find(votedUsers, func(p : Principal) : Bool { p == user })) {
      case (?user) { return "Zaten oy verdiniz!"; };
      case null { 
        noVotes += 1;
        votedUsers := Array.append(votedUsers, [user]); // Kullanıcıyı oylayanlar listesine ekliyoruz
        return "Hayır oyu verildi!";
      };
    }
  };

  // Toplam sonuçları getiren bir fonksiyon
  public func getResults() : async Text {
    return "Evet Oyları: " # Nat.toText(yesVotes) # " - Hayır Oyları: " # Nat.toText(noVotes);
  };
}
