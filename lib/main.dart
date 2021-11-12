import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  runApp(const MaterialApp(
    title: "GQL APP",
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink("https://countries.trevorblades.com/");
    final ValueNotifier<GraphQLClient> client =
        ValueNotifier<GraphQLClient>(GraphQLClient(
            link: httpLink,
            cache: GraphQLCache(
              dataIdFromObject: (object) {},
            )));
    return GraphQLProvider(
      child: const HomePage(),
      client: client,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final read = gql("""query read{
  countries{
    name
  }
}""");

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text("GraphQL Client"),
            ),
            body: Query(
                options: QueryOptions(document: read),
                builder: (QueryResult result,
                    {VoidCallback? refetch, FetchMore? fetchMore}) {
                  if (result.hasException) {
                    return Text(result.exception.toString());
                  }
                  if (result.isLoading) {
                    return const Center(
                      child: Text(
                        'Loading',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                          title:
                              Text(result.data!['countries'][index]['name']));
                    },
                    itemCount: result.data!['countries'].length,
                  );
                })));
  }
}
