# Kiszolgáló nélküli megoldások (Serverless)

## Elastic Beanstalk

Egy NodeJS alkalmazást fogunk CD folyamattal "telepíteni" Amazon ElasticBeanstalk-ra

Példa alkalmazás: https://github.com/cloudsteak/trn-node-demo

1. Nyissuk meg a Beanstalk kezelő felületét: https://eu-central-1.console.aws.amazon.com/elasticbeanstalk/home
2. Katintsunk az [Create Application](https://eu-central-1.console.aws.amazon.com/elasticbeanstalk/home/create-environment) gombra
3. `Web server environment` gomb
4. Application name: NodeJS WebApp
5. `Environment name` maradhat, amit a konzol generál
6. `Platform` szekció:
    - Platform type: `Managed platform`
    - Platform: `Node.js`
    - Platform branch: `Node.js 18`
7. Application code: `Sample application`
8. Presets: `Single instance (free tier eligible)`
9. `Next`
10. Service role: `Create and use new service role`
11. EC2 Key pair: 
    - Ha van már létező kulcs párunk, akkor válasszuk azt
    - Ha még nincs, akkor kattintsunk a `Create new key pair` linkre
12. `Next`
13. `Virtual Private Cloud (VPC)` részt nem módosítjuk
14. `Next`
15. `Configure instance traffic and scaling - optional` részt nem módosítjuk
16. `Next`
17. `Configure updates, monitoring, and logging - optional` részt nem módosítjuk
18. `Next`
19. `ReviewInfo` oldalon ellenőrizzük az eddig beállított értékeket
20. `Submit` gombra kattintva elindul a Beanstalk alkalmazásunk létrehozása
