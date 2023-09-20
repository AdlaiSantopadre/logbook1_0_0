**Logbook. Filosofia della App**

*To make as easy as possible the start of the working day.*

Prima di iniziare la specifica attività lavorativa (ad es. la
manutenzione programmata su un impianto *in itinere*), ogni giorno devo
ottemperare a tutta una serie di piccole attività iniziali (compiti, in
sintesi, di verifica e controllo degli equipaggiamenti e
dell\'autoveicolo che andrò ad utilizzare).

Sono moduli e liste di controllo da compilare in forma cartacea,
riconducibili a Ordini di servizio e Norme più in generale. Come autista
non è presupposto necessariamente che ci sia da un lato un compendio
organizzato delle attività da svolgere, e dall\'altro un unico strumento
che raccolga e tracci quanto fatto. Pertanto in partenza sarebbe ideale
raggruppare le attività di inizio giornata in un elenco gestibile *a
colpo d\'occhio*, \[specialmente per avere sotto mano scadenze, da non
dimenticare, di attività prioritarie e/o indifferibili.\]

Successivamente dal bisogno di rendicontare o consultare, potrebbe
essere resa omogenea e tradotta in forma digitale, anche la
reportistica, non impedendo all\'occorrenza una consultazione pronta ed
efficace.

**Progetto della App. Navigazione**

La UI della App si compone di 13 screen(routes) su tre livelli (di
navigazione).

Al livello 0 si trova la HomePage di tipo material che comprende un
Navigation Drawer e permette di accedere ad una maschera Popup di
autenticazione.

Dal Drawer si accede ad una serie di pagine al liv.1, una per ogni
attività della App. Queste pagine a loro volta permettono di navigare al
livello 2.

Quindi la navigazione è orizzontale solo tra HomePage \<-\> Drawer e
HomePage \<-\> Popup

Temi: l\'app definisce un tema personalizzato con combinazioni di colori
e stili di testo specifici secondo la logica del Material design di
ThemeData

![Struttura Navigazione](lib/assets/StrutturaNavigazione.png)


**HomePage**

Come pagina iniziale della App contiene i punti di accesso. È basata sul
widget *Scaffold* che costituisce la struttura portante anche di altre
pagine. Widget *Appbar oltre al titolo descrittivo del compito presenta
a destra icone con azioni collegate al proseguo della navigazione per
ottenere informazioni aggiuntive, salvataggio e recupero dei dati
persistenti, a sinistra il comando back quando non espressamente
presente l\`icona per tornare alla Home page*

Contiene l'accesso al *Drawer* per la navigazione secondo il design di
una *Material App;*

permette di scegliere e memorizzare la data della attività;

avviare la autenticazione tramite Popup;

\[consultare la lista delle scadenze\];

avere un colpo d'occhio tramite un indicatore di progresso dei compiti
svolti*Floating Action Button widget è presente ed attivo per
convalidare l\`attività svolta.Ogni compito eseguito provvede ad
incrementare un totalizzatore - accessibile e propagato da uno State
Provider Riverpod , che rappresenta lo stato di avanzamento rispetto al
100% di norma il Fl Act.Button cambia di colore per rappresentare la
attivazione e il simbolo della doppia spunta evoca il senso di
"obiettivo raggiunto ".*

Una barra a sfondo grigio orizzontale mostra attraverso la colorazione
che cambia dal rosso all\`arancio fino al verde (corrispondente al 100%)
riempie lo spazio da sinistra a destra

Se il livello di progresso raggiunto è sufficiente si può chiudere la
app \[salvando i dati aggiornati\] con esito positivo.

Il Drawer che si apre a lateralmente propone le seguenti direzioni di
navigazione, che dimostrano, attraverso i compiti da svolgere, alcune
soluzioni implementative.

**Pagina Rapporto Percorrenze**

Basata sulla classe PageVeicolo include una intestazione in cui inserire
il mese di riferimento vari campi di testo e widget per l\'acquisizione
e la visualizzazione dei dati del veicolo. Gestisce anche lo stato della
pagina.

Per questa scelta è utilizzato un widget AutoCompleteTextField con cui
passiamo l\'elenco dei nomi dei mesi validi come suggerimento.Il nome
del mese deve essere correttamente inserito perché costituisce il nome
del file associato alla tabella dei dati salvabili e recuperabili

itemBuilder definisce la modalità di visualizzazione dei suggerimenti
nell\'elenco a discesa.

itemSorter e itemFilter vengono utilizzati per ordinare e filtrare i
suggerimenti.

onSubmitted viene chiamato quando l\'utente seleziona un suggerimento.

Per cancellare il testo quando viene selezionato un suggerimento, è
utilizzata la proprietà clearOnSubmit: false. Ciò garantisce che il
suggerimento selezionato dall\'utente non venga cancellato dal campo di
input.

PageVeicolo inizializza vari controller per campi di testo. Campi di
testo: vengono utilizzati diversi campi di testo per acquisire dati
quali data, ora, chilometraggio, note e nome del conducente. Questi
campi sono organizzati in righe e ogni riga vuota viene aggiunta
dinamicamente utilizzando la funzione *addNewRow*

I/O di file: l\'app può salvare e caricare dati da/verso file in formato
JSON. Il metodo *saveDataToFile* serializza i dati immessi dall\'utente
e li scrive in un file, mentre *loadDataFromFile* legge e deserializza i
dati da un file

Le azioni della Appbar sono:

*saveDataToFile* che salva i dati inseriti dall\'utente in un file in
formato JSON.

*loadDataFromFile* che carica i dati da un file salvato in precedenza.

Selettori data e ora: il codice include selezioni data e ora per la
selezione dei valori di data e ora. Queste selezioni vengono utilizzate
per popolare i dati di data e ora nei campi di testo ricorrendo alla
libreria *flutter_rounded_date_picker*.

Pulsante di azione mobile: il pulsante di azione mobile consente agli
utenti di aggiungere nuove righe per l\'inserimento di dati aggiuntivi
del veicolo. Il pulsante è abilitato o disabilitato a seconda che siano
presenti dati nell\'ultima riga.

È possibile come da logica progettuale accedere alla documentazione
sottostante la attività da una subPageVeicolo che mostra anche il
passaggio dal cartaceo al digitale nella logica soprattutto di
semplificare e non irrigidire i procedimenti materiali.

![Rapporto percorrenze](lib/assets/RapportoPercorrenze.png)

Questo passaggio Page(x) \<-\>subPage si ripropone per ogni compito
fornendo supporto documentale, consapevolezza nell'operato e garanzia di
completezza.

![Primo Soccorso](lib/assets/Scheda_Ispezione_Periodica_Pacchetto_Di_Medicazione.PNG)

**Autenticazione**

Ho progettato l'autenticazione con una richiesta dalla HomePage.S apre
una Popup, dove username e password sono editati, la password validata
secondo regole comuni per password robuste

È predisposta una serie di provider di stato e future provider per
implementare la persistenza tramite l\`accesso ad un semplice database
gestito con la libreria *sqflite* dove si può autenticare la coppia
username-password.
