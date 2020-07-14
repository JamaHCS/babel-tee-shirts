<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <title>Client</title>
</head>
<body>
  <form action="{{ route('passport.clients.store') }}" method="post">
    <p>
      <input type="text" name="name">
    </p>
    <p>
      <input type="text" name="redirect">
    </p>
    <p>
      @csrf
      <input type="submit" value="Send">
    </p>
  </form>

  {{ $clients }}
</body>
</html>
