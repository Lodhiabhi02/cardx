import 'package:cardx/core/failure.dart';
import 'package:fpdart/fpdart.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>; //custom type

typedef FutureEitherVoid =
    FutureEither<void>; // same using void instead T
