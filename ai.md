# AWS AI/ML szolgáltatások


## Amazon BedRock

Az Amazon BedRock egy felügyelt szolgáltatás, amely lehetővé teszi, hogy könnyedén létrehozzunk és skálázzunk generatív AI alkalmazásokat nagy nyelvi modellek (LLM-ek) segítségével anélkül, hogy saját AI infrastruktúrát kellene kezelni. Az Amazon BedRock hozzáférést biztosít több vezető AI modellhez, beleértve az AI21 Labs, Anthropic, Cohere és mások modelljeit.

### Példa

A ChatGPT-hez hasonló alkalmazás létrehozása az Amazon BedRock segítségével. Adunk majd egy rednszer promptot, amely meghatározza a chatbot viselkedését, majd a felhasználói bemenet alapján a modell generálja a választ.

1. Megnyitjuk az Amazon BedRock konzolt.
2. A "Test" alatt kiválasztjuk a "Chat / Text playground" lehetőséget.
3. "Select model" alatt kiválasztjuk a "Claude Sonnet 4" modellt.
4. A "System" mezőbe beírjuk a következő promptot:
    ```bash
    Te egy képgaléria vezetője vagy amikor egy képet látsz, akkor azt művészeti érték szerint elemzed. Forintban adsz egy becslést a kép értékére. 
    ```
5. A "User" mezőben feltöltünk egy képet.
6. Kattintsunk a "Run" gombra.


Lehetséges egyéb rendszer promptok:
- Te egy marketing szakértő vagy, aki segít a felhasználóknak hatékony marketing kampányokat létrehozni a feltöltött kép alapján.
- A feltöltött kép alapján, Te mint egy divat szakértő, adj tanácsokat a felhasználóknak a legújabb divat trendekről és stílusokról.
- Te egy utazási tanácsadó vagy, aki segít a felhasználóknak utazási terveket készíteni a feltöltött kép alapján.


Próbáljuk meg módosítani az alábbi paramétereket is:
- Temperature: A válasz kreativitását szabályozza. Magasabb érték (pl. 0.8) kreatívabb válaszokat eredményez, míg alacsonyabb érték (pl. 0.2) konzervatívabb válaszokat ad.
- Top P: A válasz sokszínűségét szabályozza. Magasabb érték (pl. 0.9) több változatosságot eredményez, míg alacsonyabb érték (pl. 0.3) fókuszáltabb válaszokat ad.
- Top K: A válaszban figyelembe vett legvalószínűbb tokenek számát szabályozza. Magasabb érték (pl. 50) több változatosságot eredményez, míg alacsonyabb érték (pl. 10) fókuszáltabb válaszokat ad.


## Amazon Sagemaker

Az Amazon SageMaker egy felügyelt szolgáltatás, amely lehetővé teszi az adatelemzők és fejlesztők számára, hogy gyorsan és egyszerűen építsenek, tanítsanak és telepítsenek gépi tanulási modelleket nagy léptékben. Az Amazon SageMaker számos beépített algoritmust, előre elkészített környezetet és integrációt kínál más AWS szolgáltatásokkal, amelyek megkönnyítik a gépi tanulási projektek kezelését.
