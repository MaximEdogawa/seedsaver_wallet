import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:provider/provider.dart';

import 'package:seedsaver_wallet/views/qrview.dart';
import 'package:seedsaver_wallet/views/vaultview.dart';
import 'package:seedsaver_wallet/widgets/load_createQr_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Seedsaver_wallet',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ),
        home: HomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var history = <WordPair>[];

  GlobalKey? historyListKey;

  void getNext() {
    history.insert(0, current);
    var animatedList = historyListKey?.currentState as AnimatedListState?;
    animatedList?.insertItem(0);
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite([WordPair? pair]) {
    pair = pair ?? current;
    if (favorites.contains(pair)) {
      favorites.remove(pair);
    } else {
      favorites.add(pair);
    }
    notifyListeners();
  }

  void removeFavorite(WordPair pair) {
    favorites.remove(pair);
    notifyListeners();
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FileTransferWidget(
            textContent:
                '2858985350551563022763249116671486615562812930998478524901590194738104275671915020482310143854904012644252338258097210760223670610984072379180714540701832711757983537463813312671679858941644783235922398587853792322120934385823650798576598271855664180185896775644429183015837182874402705325765368692927697093312242783866870167644159852413644404022169598326737967858787837285899185278581644287436204134385566417978537243644067057049583267380798587878378858991852785816441834294903039010066279385243980820067373052013474407202705325761197490112322961395442949025278556904175858967399075161907306309277720053582644805389763198581709755858157888043118105598523611371858942053608053023518065646560536869292765430936964294902271431181030500336860198589414392228222974408074034885368692863858993450055028618758589805571852309094385894778800805302335806564656021433384446442418815434529869285582151660335543343848769842432203939702418016225429177241565430892798573943604856221337406377963481610213368322122156781642086560538976319752040352021642606090386006531006710785185894184958358199280536870137575392777685377097604858987263903860065970067107927846829976804047482960536862783756650841565430844804294902271028527871801009244278589418488322122140780593551044294951103676960653042783866870167651327003368601985894143920805302335858810774680572579204286676991436207591385733806078523220542013421569583246417118587878368322120940764927824664280025087016766822300336860180067633144053584281580635423998585822207646759103985734848028589806078067108763584997570481342173231815162979253645639676484361983645087244885732231690033686525691247718383246417118587878368322120940764927824664280025087016766822300336860180067372039832307609580572500640541048928214745113543787929598556772981858967756404026511758327790576268248678375371494397520403520215590515285565772798523349003858941848864419307518057250064054104892810820978564294967042858980556785254461838485341183832359223985878702077621036927858157894442949022710033816321006684825985230899120403697855818098992142916412901082130309857715507104025533438525970643847904972014774435686440853503752876255985817096974294903039026843495385896847327113122823845624320802705325774291641312107795257642949025278556904446053661440385894143923221221392161060463977133249932139193343437879039943118103058589675516630823120783246448482682372080053897628821474511354496293633006698060900668482598457289720107373827181033952972143485893322545254343284574711644166665852597094600676331440535857160053478607975224924798581709823432849727957108499196296142715148112731876192470362582385131021962900661353462662090860448833705791628254131365710237566548728205327809319660359580414206382370458525572168051026500492001766552294762453425335267549967855327333532683542569574753701119985570355180133958655845676341585888941922684346527765460473721406678402155937791010066279185479915480267917311832569342453667102717528765375858170969742949030398557953022006763314804022251518326737967858787838421537750721077952576429490303943624693750033686018006763314405358346238061452257214486220764508888318573288194857302630203352852478458336303858890648064424429117616856001214066790343788531228573420287855691059001342157198457551864026948814405389762882147451135434529869185898086386442449924033606860005358346103758088351752877561721392916474378790911855703505585896775646442448935858889829610768875362172641343858170976075161601284311810305003368652784567634600135262232027052446410737255676513770623432019865500669793268254389267845728972013411532798063541631858582214985899024635100273412857338675100336860180067372036026739303205368628798585773055858991119985784655381744830076033528422001945108478324640815858787017664424346876467590527857348480285898060780939523091858943487308053024638147429008107372620767360521018575451135040254515062078310780134215775835819539185879357175366620192107796883221559051528589804055006684825985894164416174011471805935510453646131196484393857428127027101676426238524135519852308890002684314398587935743752041977875245812504294904831855651225403693603860067372036013526628816106046717541358528428674240485898698233053452809852361215606705930238326742000268242121937622906252147451519496600460885898060798523612156053686894384483730160536862783752877561685899050235804916481005046271801339586558457814009026771252785878537923221209343858187354585758773758556641797858967654384609579198415350783805724995185857567997377813503432845836843283914258589674492114111487204037017441071714320106957215985816113934294902783856070524700671078478457289720107373788781369428961073725567646761664185898716151878962945858967449206707281918322553871858785379305389843843229613952857371456085565772798523349026006763111601352622320536862783752877561685899060478573353983013421723585275434420134215695832464484821474757757692345120214745113543118754564328391425855651225202015907838323592271822083121610737255676513770623432016614300504624650033686018006737305583235922398587870207766298214373778134404294902271028527871801007953880201848871858890648305368628798585936895646759103985734848028589806078483183720385894164414026527823805935510453686930557533015039857348481185898060790109051394006737305201347440798322551824054105680021433057924294903039855703508185896775658187020292026843143985878783831073725759858164418142949030390100662793852439858806708306028589930575810339124805389762882147451519510024102443118753290033686527858941644783256934260536863423805724992059014022398573288196858980607827514624198501853188013526628816092610557537148095858170974385898703358557035518020110847984583362798588906480322121743975665243532139881408215590515243285212498589690876644219290584567634241475350559858582220764843938574281794559016764262385241358398589420543832464151985878783683221209407858170970185816785274328456449003381606600673720398457819128053686287985858221762147455103647608716843284564490033686018006763314405358571600534786079756651027185819390944283990271855795258185896847324697618527836868244005348188478585936840644241855951506050608556773374033529036784583382963220361202671297947205389763198581939094428661158443118755820201325583858942668014774435681071742975752043622364675900158573484802858980607806709580820067633144080445030380635413438585822147429078944021559377910066983935852308991607384616880403701744161060467176336332164286676911429490303901006627938589675519845781400867108823201071804447858577299485899019534281073413432852121985259714520135788591836711425580562175997537164225214745395146305113614362011134399323904200673720398588890200053478607975371642252140438527437885313685898132470115342856016751206383256934253220193319858991827232295979478581578880857322316985896755173623876647832464484826830438397537164225214745126350163873328556773374033528831984583363518588906481429392283205389763196840942591437885312485898050543690986515845728972013414236158063549408321780121564843615998573485055016770765342949662918462008312134166120385888901280541057056107796883221559051528573223423852335001400673720360134744072053478606410737257598581599283404321121158783227897831758948112344546709321196257676302320597626127477129318394378853121539281506622385163165867668658135858137536955195011048284411260395678558663524958589806079852335001443302581557353945362733458675503756452282527771413740055084902506360101144047718440397668820332939810886150087386624842229280569823401171321276748680060124339518523879111845781882410811227841612718112213914425621641958398589885637774113631339976986593034759846855935300055739701746012242513815457981217945062430066848767845676341585894276415792342000454496729621443423677602565764797764599444384984267216638236023073862537285298530200545869426563993543452986898556773374013395865584578140082683355135805934716785858221446442418815857394380700338165740201069567845833627985889064828588890128053898444764843735036450872448431187558201339586520805304359837183076826843464638585805765858990207943787939834353622527852322073401336965198456243208053686278375518526076455066623437885312185898050558523874300107322880785888941926442442784322120927964843938584278386687016764620700336860198589416440134217326380593551045364744160107795257642949022710402652674013396121801336965198324644848214561587175245651836501171074427838668701677716538589676543846882405602705288240536862783756652435221726223354387307519006698393585230909400804871172026739303985878783997537164229858220134343202640648564179455003368601801342156881477439512053478606410737257598581611393429490227101006627878523611227858942053608053023518587861985429142022385817097398589870335020126131300336860198589420543832359628780576839365364531327858164416142949027830201326083852361124385894205360805302351808242377653686935036601834373857610626043285212398527806460161012735983340786718179949537161480697885821684538589872127150988416100336865260067372036026843137661761044961073725631858167693085898695670167646207852361215605368688878588902399807402780775896094716459195775857341951911072957938546418684013500519185888941920541061136106957215975204197126459227905855677337402684344438589418490697931779180593551044294951551679475500842949022710033816574013395865584578140082683478015805934844785858221446442418815577136205285898050544227857427845728972013411778480269488159805516905610779688954328456449857322342201007953880201850872053583462380614522572143977471646759001585734848028589806078483183720385894164418321495119805935510453647113921077952639645087244843118755820133958655845781400902684317118271162224054106515242866117116450904833432845644985232194598456505343832359223981012981445364563967648436300785734848118589806078161048217800673720398588894192456445948816148069764286676875429490303901006627938526495740067058892783267383038322551824053897631964550503676450904833432852123985278064601610180600443023358464405094397566509247858193909442821552630184680446080506367984572878958588906480161060470375497471372147452415504988787285732231690033816572161018060401347440720534798335753296992185817263358573288203858980403785896755168455714855832464484826823393120538976319858164419142949030390100662793852649523400673720398588894192644244278421433794882139144319432016614385570355180134217345044452553114143372425048468235167589793128643875484755407111403327645008184391758540028761806100623452715073476692434500772895708250464506254070896767270784063010237324667615688085247340090841379522058071402368699480501138193174868530571633120743834002684314398587850762216561096660085378790335574666798991094408103022695186353612377513411866372567037537164224322958150421559052798573288256646643890458126339202200711546507566494527271893703585160353763219285343614847992179108368018998068651234957102276150098095631648653533581163659723533464382242100671088600402651151832464484810716692477532954367858161139342949027838557690379858970316416106109358588935152644244284775455528332139193343437879398343118103050033686019858941439208043560828323596256214342864021391443198573288196858980607803355433158458862584134217323180677437125364563967648436428764508724488573223169006710785184682981080134746096080740348853686928636870237567857341951902683072018589674492161061069608053023198067743712536456396764843624956450872448858980505404697610438457289720134118604002694881441073725567654311411243284576004328391425852321945985894205438323270730639268225237644100191901369061091589443580603172493431271133182469619158177390120037207942079754240184393903402164195712432852121985648651427232723031856475103507308512427544257626083370623366962794291507729949812007449837126967291122310255179176397705740260235601465130178594394013835922761748108287858967449583235962752146697845408974231216286010277948933458597547366700873600076597172680380685429903502162401073728767779218144217451856507547149870294145103342387009974683888082590613726312993485972143428045338903065585646375055745721839669939606334779106213777030873134007014857847887437022504835663587660985897359344339587059721650504744672669060234590356783506999443639259230282142704015911821001342161678456243215832255590381902946512427298187502842587823173063197978132705549974467135467200701807035885818785073724658090147526405442119211556346066928673764740279480541862684900021114833943584108213038424432384354808460341379554583171265724204697462352630675772313288213355171738623857335398300669793278523349011858942053667108823838587935743752876230385817096974294903039020132608985354086360671086615838755940826822819837537164225213929164743787909110788595199003368601985230889000134746101832359220805410651532147451519504994176185611645458589677567845833639185889064858588890128107165289610821303064294902271858983948785236113760671086607832255999980593551044290871295645919577546808430128556773374033529651184583382963220418559807822191977699645436543089023857394361085898096621274849795846069964783340788958078229473429108425610779525764286611584431187558200701245400201850872322041855980782219197602192383654308902385739436108589809662127484979584586024958334078895858786198675161767036467616642427871436701677716718527805514013395661201347461118078221919805516905610820980478573419519026830720185896744921610610696080530231981851842245364563967648436249564508724488589805054422785742784572897201341186040026948814410737255676543114112432845760043283914258523219459858942054383232051145474252795624900293065181679181648868292695842372835140641073676259747768396491226843464201042132239464814393807137796957128361200571632561564873984956700428907073156966385858222076456113144196518126432464440127462368010530067096352290295627861843145713368788735735144322155905279443699752400671084802640214160419509921529692542431420592463645507651221800650516209428735494525542244069646117501422935640251325662706324055983158194031362911805246253670253169378006737305584431339518423521468175586792504856645935557188776505474857034382393963116055344839420056977204162135390357142497796511440412820378579521217295627743513235968361023761491604536759601744186136013039489493967864517440849712444522582005300497426236525163490974841352768182355306439658241265770671906424107512430233681892862798140353773830318077988060160');
        break;
      case 2:
        page = QRView();
        break;
      case 3:
        page = VaultPage(
          cardsData: [
            VaultCardData(
              backgroundColor: Colors.grey.shade900,
            ),
            VaultCardData(
              backgroundColor: Colors.cyan,
            ),
            VaultCardData(
              backgroundColor: Colors.blue,
            ),
            VaultCardData(
              backgroundColor: Colors.purple,
            ),
          ],
        );
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    var mainArea = ColoredBox(
      color: colorScheme.surfaceVariant,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: page,
      ),
    );

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 450) {
            return Column(
              children: [
                Expanded(child: mainArea),
                SafeArea(
                  child: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.favorite),
                        label: 'Favorites',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.qr_code),
                        label: 'QR',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.safety_check),
                        label: 'Vaults',
                      ),
                    ],
                    currentIndex: selectedIndex,
                    onTap: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                )
              ],
            );
          } else {
            return Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 600,
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.favorite),
                        label: Text('Favorites'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.qr_code),
                        label: Text('QR'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.safety_check),
                        label: Text('Vaults'),
                      ),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                ),
                Expanded(child: mainArea),
              ],
            );
          }
        },
      ),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(
            flex: 3,
            child: HistoryListView(),
          ),
          const SizedBox(height: 10),
          BigCard(pair: pair),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: const Text('Like'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: const Text('Next'),
              ),
            ],
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    Key? key,
    required this.pair,
  }) : super(key: key);

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 200),
          // Make sure that the compound word wraps correctly when the window
          // is too narrow.
          child: MergeSemantics(
            child: Wrap(
              children: [
                Text(
                  pair.first,
                  style: style.copyWith(fontWeight: FontWeight.w200),
                ),
                Text(
                  pair.second,
                  style: style.copyWith(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return const Center(
        child: Text('No favorites yet.'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(30),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        Expanded(
          // Make better use of wide windows with a grid.
          child: GridView(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400,
              childAspectRatio: 400 / 80,
            ),
            children: [
              for (var pair in appState.favorites)
                ListTile(
                  leading: IconButton(
                    icon: const Icon(Icons.delete_outline,
                        semanticLabel: 'Delete'),
                    color: theme.colorScheme.primary,
                    onPressed: () {
                      appState.removeFavorite(pair);
                    },
                  ),
                  title: Text(
                    pair.asLowerCase,
                    semanticsLabel: pair.asPascalCase,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class HistoryListView extends StatefulWidget {
  const HistoryListView({Key? key}) : super(key: key);

  @override
  State<HistoryListView> createState() => _HistoryListViewState();
}

class _HistoryListViewState extends State<HistoryListView> {
  /// Needed so that [MyAppState] can tell [AnimatedList] below to animate
  /// new items.
  final _key = GlobalKey();

  /// Used to "fade out" the history items at the top, to suggest continuation.
  static const Gradient _maskingGradient = LinearGradient(
    // This gradient goes from fully transparent to fully opaque black...
    colors: [Colors.transparent, Colors.black],
    // ... from the top (transparent) to half (0.5) of the way to the bottom.
    stops: [0.0, 0.5],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    appState.historyListKey = _key;

    return ShaderMask(
      shaderCallback: (bounds) => _maskingGradient.createShader(bounds),
      // This blend mode takes the opacity of the shader (i.e. our gradient)
      // and applies it to the destination (i.e. our animated list).
      blendMode: BlendMode.dstIn,
      child: AnimatedList(
        key: _key,
        reverse: true,
        padding: const EdgeInsets.only(top: 100),
        initialItemCount: appState.history.length,
        itemBuilder: (context, index, animation) {
          final pair = appState.history[index];
          return SizeTransition(
            sizeFactor: animation,
            child: Center(
              child: TextButton.icon(
                onPressed: () {
                  appState.toggleFavorite(pair);
                },
                icon: appState.favorites.contains(pair)
                    ? Icon(Icons.favorite, size: 12)
                    : const SizedBox(),
                label: Text(
                  pair.asLowerCase,
                  semanticsLabel: pair.asPascalCase,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
