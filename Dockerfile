FROM dart:3.0.3
WORKDIR /tunza

COPY pubspec.* ./
RUN dart pub get

COPY . .

RUN dart pub get --offline

CMD ["dart", "run", "lib/main.dart"]

EXPOSE 8080


