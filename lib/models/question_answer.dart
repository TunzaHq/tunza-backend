class Answers {
  final int id;
  final int question_id;
  final int claim_id;
  final String answer;
  final DateTime createdAt;
  final DateTime updatedAt;

  Answers({
    required this.id,
    required this.question_id,
    required this.claim_id,
    required this.answer,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Answers.fromPostgres(List row) => Answers(
        id: row[0],
        question_id: row[1],
        claim_id: row[2],
        answer: row[3],
        createdAt: row[4],
        updatedAt: row[5],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question_id": question_id,
        "claim_id": claim_id,
        "answer": answer,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };

  @override
  String toString() {
    return 'Answers(id: $id, question_id: $question_id, claim_id: $claim_id, answer: $answer, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

class Questions {
  final int id;
  final int plan_id;
  final String question;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String expects;

  Questions({
    required this.id,
    required this.plan_id,
    required this.question,
    required this.createdAt,
    required this.updatedAt,
    required this.expects,
  });

  factory Questions.fromPostgres(List row) => Questions(
        id: row[0],
        plan_id: row[1],
        question: row[2],
        createdAt: row[3],
        updatedAt: row[4],
        expects: row[5],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "plan_id": plan_id,
        "question": question,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "expects": expects,
      };

  @override
  String toString() {
    return 'Questions(id: $id, plan_id: $plan_id, question: $question, createdAt: $createdAt, updatedAt: $updatedAt, expects: $expects)';
  }
}
