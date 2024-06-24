export default function generateData({ amountOfRecords }) {
    return [...Array(amountOfRecords)].map((_, index) => {
        return {
            apexName: `Name (${index})`,
            dateProcessed: new Date(
                Date.now() + 86400000 * Math.ceil(Math.random() * 20)
            ),
            status: `Status (${index})`,
            csvUrl: 'www.salesforce.com',       
        };
    });
}